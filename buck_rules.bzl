
DEFAULT_CONFIGS = {
  'SWIFT_OPTIMIZATION_LEVEL' : '-Owholemodule',
  'SWIFT_WHOLE_MODULE_OPTIMIZATION': 'YES',
  'ONLY_ACTIVE_ARCH': 'YES',
  'SDKROOT': 'iphoneos',
}

POD_CONFIGS = DEFAULT_CONFIGS
POD_CONFIGS['GCC_TREAT_WARNINGS_AS_ERRORS'] = 'YES'



library_configs = {
    "Debug": DEFAULT_CONFIGS,
    "Profile": DEFAULT_CONFIGS,
    "Release": DEFAULT_CONFIGS,
}

pod_library_configs = {
    "Debug": POD_CONFIGS,
    "Profile": POD_CONFIGS,
    "Release": POD_CONFIGS,
}

def pod_library(name, **kwargs):
  apple_lib(name, **kwargs)

def apple_test_lib(name, **kwargs):
  substitutions = {
    'CURRENT_PROJECT_VERSION': '1',
    'DEVELOPMENT_LANGUAGE': 'en-us',
    'PRODUCT_BUNDLE_IDENTIFIER': 'com.company.%s' % name,
  }
  native.apple_test(name=name, 
  info_plist_substitutions=substitutions, 
  frameworks = ["$PLATFORM_DIR/Developer/Library/Frameworks/XCTest.framework"],
  **kwargs)

def apple_lib(
  name,
  swift_version = '4',
  modular = True,
  compiler_flags = None,
  swift_compiler_flags = None,
  warning_as_error = True,
  **kwargs
):
  

  compiler_flags = compiler_flags or []
  swift_compiler_flags = swift_compiler_flags or []

  # Don't treat warnings as errors for Beta Xcode versions
  if native.read_config('xcode', 'beta') == 'True':
    warning_as_error = False

  # Remove once we fix all new warnings with Xcode 10
  warning_as_error = False

  if warning_as_error:
    compiler_flags.append('-Werror')
    swift_compiler_flags.append('-warnings-as-errors')
  else:
    compiler_flags.append('-w')
    swift_compiler_flags.append('-suppress-warnings')

  native.apple_library(
    name=name,
    swift_version=swift_version,
    configs = library_configs,
    modular=modular,
    compiler_flags=compiler_flags,
    swift_compiler_flags=swift_compiler_flags,
    **kwargs
  )

