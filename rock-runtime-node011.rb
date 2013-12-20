require 'formula'

class RockRuntimeNode011 < Formula
  homepage 'http://nodejs.org/'
  url 'http://nodejs.org/dist/v0.11.9/node-v0.11.9.tar.gz'
  sha1 'b4fc0e38ccde4edae45db198f331499055d77ca2'

  keg_only 'rock'

  depends_on :python => ['2.6', :build]

  # https://gist.github.com/bbhoss/7439859/raw/9037240e90c62ce462383469874d4c269e3ead0d/xcode_emulation.patch
  def patches; DATA; end

  def install
    system './configure', "--prefix=#{prefix}"
    system 'make', 'install'

    (prefix + 'rock.yml').write <<-EOS.undent
      env:
        PATH: "#{bin}:${PATH}"
    EOS

    runtime = var + 'rock/opt/rock/runtime'
    runtime.mkpath
    runtime += 'node011'
    system 'rm', '-fr', runtime if runtime.exist?

    File.symlink(prefix, runtime)
  end
end

__END__
diff --git a/tools/gyp/pylib/gyp/xcode_emulation.py b/tools/gyp/pylib/gyp/xcode_emulation.py
index f9cec33..4b3c035 100644
--- a/tools/gyp/pylib/gyp/xcode_emulation.py
+++ b/tools/gyp/pylib/gyp/xcode_emulation.py
@@ -285,8 +285,14 @@ class XcodeSettings(object):
     if sdk_root.startswith('/'):
       return sdk_root
     if sdk_root not in XcodeSettings._sdk_path_cache:
-      XcodeSettings._sdk_path_cache[sdk_root] = self._GetSdkVersionInfoItem(
-          sdk_root, 'Path')
+      try:
+        XcodeSettings._sdk_path_cache[sdk_root] = self._GetSdkVersionInfoItem(
+            sdk_root, 'Path')
+      except:
+        # if this fails it's because xcodebuild failed, which means
+        # the user is probably on a CLT-only system, where there
+        # is no valid SDK root
+        XcodeSettings._sdk_path_cache[sdk_root] = None
     return XcodeSettings._sdk_path_cache[sdk_root]

   def _AppendPlatformVersionMinFlags(self, lst):
@@ -397,10 +403,11 @@ class XcodeSettings(object):

     cflags += self._Settings().get('WARNING_CFLAGS', [])

-    config = self.spec['configurations'][self.configname]
-    framework_dirs = config.get('mac_framework_dirs', [])
-    for directory in framework_dirs:
-      cflags.append('-F' + directory.replace('$(SDKROOT)', sdk_root))
+    if 'SDKROOT' in self._Settings():
+      config = self.spec['configurations'][self.configname]
+      framework_dirs = config.get('mac_framework_dirs', [])
+      for directory in framework_dirs:
+        cflags.append('-F' + directory.replace('$(SDKROOT)', sdk_root))

     self.configname = None
     return cflags
@@ -647,10 +654,11 @@ class XcodeSettings(object):
     for rpath in self._Settings().get('LD_RUNPATH_SEARCH_PATHS', []):
       ldflags.append('-Wl,-rpath,' + rpath)

-    config = self.spec['configurations'][self.configname]
-    framework_dirs = config.get('mac_framework_dirs', [])
-    for directory in framework_dirs:
-      ldflags.append('-F' + directory.replace('$(SDKROOT)', self._SdkPath()))
+    if 'SDKROOT' in self._Settings():
+      config = self.spec['configurations'][self.configname]
+      framework_dirs = config.get('mac_framework_dirs', [])
+      for directory in framework_dirs:
+        ldflags.append('-F' + directory.replace('$(SDKROOT)', self._SdkPath()))

     self.configname = None
     return ldflags
@@ -826,7 +834,10 @@ class XcodeSettings(object):
         l = '-l' + m.group(1)
       else:
         l = library
-    return l.replace('$(SDKROOT)', self._SdkPath(config_name))
+    if self._SdkPath():
+      return l.replace('$(SDKROOT)', self._SdkPath(config_name))
+    else:
+      return l

   def AdjustLibraries(self, libraries, config_name=None):
     """Transforms entries like 'Cocoa.framework' in libraries into entries like
