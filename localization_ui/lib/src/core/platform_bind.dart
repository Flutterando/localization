import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:modular_interfaces/modular_interfaces.dart';

import 'package:universal_io/io.dart';

typedef InjectBuild<T extends Object> = T Function(Injector i);

class PlatformBind<T extends Object> extends Bind<T> {
  PlatformBind({
    InjectBuild<T>? web,
    InjectBuild<T>? windows,
    InjectBuild<T>? macos,
    InjectBuild<T>? linux,
    InjectBuild<T>? android,
    InjectBuild<T>? ios,
    required InjectBuild<T> orElse,
    bool export = false,
    void Function(T value)? onDispose,
    dynamic Function(T value)? selector,
    bool isSingleton = true,
    bool isLazy = true,
    bool alwaysSerialized = false,
  }) : super(
          (kIsWeb 
                  ? web : Platform.isWindows 
                  ? windows : Platform.isMacOS 
                  ? macos : Platform.isLinux 
                  ? linux : Platform.isAndroid
                  ? android : Platform.isIOS
                  ? ios : null
          ) ?? orElse,
          isSingleton: isSingleton,
          isLazy: isLazy,
          export: export,
          onDispose: onDispose,
          selector: selector,
          alwaysSerialized: alwaysSerialized,
        );
  
  ///Bind  an already exist 'Instance' of object..
  factory PlatformBind.instance({
    InjectBuild<T>? web,
    InjectBuild<T>? windows,
    InjectBuild<T>? macos,
    InjectBuild<T>? linux,
    InjectBuild<T>? android,
    InjectBuild<T>? ios,
    required InjectBuild<T> orElse,
    bool export = false,
    dynamic Function(T value)? selector,
  }) {
    return PlatformBind<T>(
      web:web,
      windows:windows,
      macos:macos,
      linux:linux,
      android:android,
      ios:ios,
      orElse: orElse,
      isSingleton: false,
      isLazy: true,
      export: export,
      selector: selector,
    );
  }

  ///Bind a 'Singleton' class.
  ///Built together with the module.
  ///The instance will always be the same.
  static Bind<T> singleton<T extends Object>({
    InjectBuild<T>? web,
    InjectBuild<T>? windows,
    InjectBuild<T>? macos,
    InjectBuild<T>? linux,
    InjectBuild<T>? android,
    InjectBuild<T>? ios,
    required InjectBuild<T> orElse,
    bool export = false,
    void Function(T value)? onDispose,
    dynamic Function(T value)? selector,
  }) {
    return PlatformBind<T>(
      web: web,
      windows: windows,
      macos: macos,
      linux: linux,
      android: android,
      ios: ios,
      orElse: orElse,
      isSingleton: true,
      isLazy: false,
      export: export,
      onDispose: onDispose,
      selector: selector,
    );
  }

  ///Create single instance for request.
  static Bind<T> lazySingleton<T extends Object>({
    InjectBuild<T>? web,
    InjectBuild<T>? windows,
    InjectBuild<T>? macos,
    InjectBuild<T>? linux,
    InjectBuild<T>? android,
    InjectBuild<T>? ios,
    required InjectBuild<T> orElse,
    bool export = false,
    void Function(T value)? onDispose,
    dynamic Function(T value)? selector,
  }) {
    return PlatformBind<T>(
      web: web,
      windows: windows,
      macos: macos,
      linux: linux,
      android: android,
      ios: ios,
      orElse: orElse,
      isSingleton: true,
      isLazy: true,
      export: export,
      onDispose: onDispose,
      selector: selector,
    );
  }

  ///Bind a factory. Always a new constructor when calling Modular.get
  static Bind<T> factory<T extends Object>({
    InjectBuild<T>? web,
    InjectBuild<T>? windows,
    InjectBuild<T>? macos,
    InjectBuild<T>? linux,
    InjectBuild<T>? android,
    InjectBuild<T>? ios,
    required InjectBuild<T> orElse,
    bool export = false,
  }) {
    return PlatformBind<T>(
      web: web,
      windows: windows,
      macos: macos,
      linux: linux,
      android: android,
      ios: ios,
      orElse: orElse, 
      isSingleton: false, 
      isLazy: true, 
      export: export,
    );
  }
}