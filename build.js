({
  baseUrl: './dist/src',
  name: 'main',
  out: './dist/JasmineSugar.js',
  optimize: 'none',
  onModuleBundleComplete: function (data) {
    var fs = module.require('fs'),
      amdclean = module.require('amdclean'),
      outputFile = data.path,
      cleanedCode = amdclean.clean({
        'filePath': outputFile,
        'transformAMDChecks': false
      });

    fs.writeFileSync(outputFile, cleanedCode);
  }
})