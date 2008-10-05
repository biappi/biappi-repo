import xml.sax.handler
import sys

vcproj2make = {
	'OutputDirectory': '_OUTPUT_DIRECTORY',
	'IntermediateDirectory': '_INTERMEDIATE_DIRECTORY',
	'AdditionalIncludeDirectories': '_ADDITIONAL_INCLUDE_DIRECTORIES',
	'PreprocessorDefinitions': '_PREPROCESSOR_DEFINITIONS'
}

def vsarglist2gcclist(string, gcc_opt, sep=';'):
	return gcc_opt + (' ' + gcc_opt).join(string.split(sep))

def wincopy2unixcopy(string):
	return string.replace("COPY ","copy ").replace("copy /Y ","cp -f ").replace("copy ","cp ").replace( "\\", "/").replace( "\r\n", ";" ).replace(";;",";")

class VisualStudioTools:
	@classmethod
	def VCCLCompilerTool(cls, handler, attrs):
		defines = vsarglist2gcclist(attrs['PreprocessorDefinitions'], '-D').replace('-DWIN32', '-DLINUX')
		includes = vsarglist2gcclist(attrs['AdditionalIncludeDirectories'].replace('\\', '/'), '-I').replace('External/pthreads/include', '')
		
		handler.build_variables.append((handler.current_configuration + vcproj2make['AdditionalIncludeDirectories'], includes))
		handler.build_variables.append((handler.current_configuration + vcproj2make['PreprocessorDefinitions'], defines))

	@classmethod
	def VCLibrarianTool(cls, handler, attrs):
		of = handler.winpath2unixpath(attrs['OutputFile']).replace('.lib', '.a').replace(handler.name, 'lib' + handler.name)
		handler.output_file[handler.current_configuration] = of
	
	@classmethod
	def VCPostBuildEventTool(cls, handler, attrs):
		handler.post_build[handler.current_configuration].append( (attrs['Description'], wincopy2unixcopy(attrs['CommandLine'])) )

	@classmethod
	def VCCustomBuildTool(cls, handler, attrs):
		handler.post_build[handler.current_configuration].append( (attrs['Description'], wincopy2unixcopy(attrs['CommandLine'])) )

class VCProjHandler(xml.sax.handler.ContentHandler):
	def __init__(self):
		self.build_variables = []
		self.source_files = []
		self.name = None
		self.output_file = {}
		self.post_build = {}
		self.configurations = []
		self.configuration_types = {}

	def startElement(self, name, attrs):
		if name == 'VisualStudioProject':
			self.name = attrs['Name']
		
		if name == 'Configuration':
			self.current_configuration = attrs['Name'].split('|')[0].upper()
			self.configurations.append(self.current_configuration)
			self.build_variables.append((self.current_configuration + vcproj2make['OutputDirectory'], self.winpath2unixpath(attrs['OutputDirectory'])))
			self.build_variables.append((self.current_configuration + vcproj2make['IntermediateDirectory'], self.winpath2unixpath(attrs['IntermediateDirectory'])))
			self.configuration_types[self.current_configuration] = attrs['ConfigurationType']
			self.post_build.update({self.current_configuration: []})
			self.output_file.update({self.current_configuration: None})

		if name == 'Tool':
			try:
				getattr(VisualStudioTools, attrs['Name'])(self, attrs)
			except:
				pass
		
		if name == 'File':
			if '.c' in attrs['RelativePath']:
				self.source_files.append(attrs['RelativePath'].replace('\\', '/'))
	
	def winpath2unixpath(self, string):
		res = string
		res = res.replace('win32-msvc2005', 'make-build')
		res = res.replace('$(IntDir)', '$(' + self.current_configuration + '_INTERMEDIATE_DIRECTORY)')
		res = res.replace('$(OutDir)', '$(' + self.current_configuration + '_OUTPUT_DIRECTORY)')
		res = res.replace('$(ProjectName)', self.name)
		res = res.replace('$(ConfigurationName)', self.current_configuration.lower())
		res = res.replace('$(ProjectDir)', '')
		res = res.replace('\\', '/')
		return res

	def do_makefile(self):
		res = []
		res.extend(map(lambda x: x[0] + " = " + x[1], self.build_variables))
		
		for conf in self.configurations:
			res.append('')
			res.append(conf.lower() + '_' + self.name + ':')

			res.append('\tif [ ! -d $(' + conf + '_INTERMEDIATE_DIRECTORY) ]; then mkdir -p $(' + conf + '_INTERMEDIATE_DIRECTORY) ; fi')
                        res.append('\tif [ ! -d $(' + conf + '_OUTPUT_DIRECTORY) ]; then mkdir -p $(' + conf + '_OUTPUT_DIRECTORY) ; fi')
			res.append('')

			objfiles = []
			for file in self.source_files:
				objfile = '$(' + conf + '_INTERMEDIATE_DIRECTORY)/' + file.split('/')[-1].replace('.cpp', '.o')
				objfiles.append(objfile)
				res.append('\tg++ $(' + conf + '_PREPROCESSOR_DEFINITIONS) $(' + conf + '_ADDITIONAL_INCLUDE_DIRECTORIES) -o ' + objfile +' -c ' + file)


			res.append('')

			for desc, cmdline in self.post_build[conf]:
				res.append('\t@echo ' + desc)
				res.append('\t' + cmdline)

			res.append('')

			if self.configuration_types[conf] == '4': # Visual Studio constant being library
				if self.output_file[conf] is not None:
					res.append('\tar rcs ' + self.output_file[conf] + ' ' + ' '.join(objfiles)) 

		return '\n'.join(res)

if __name__ == '__main__':
	h = VCProjHandler()
	p = xml.sax.parse(open(sys.argv[1], 'r'), h)

	print h.do_makefile()
