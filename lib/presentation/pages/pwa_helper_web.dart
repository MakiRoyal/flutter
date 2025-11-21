// Web-specific implementation using dart:js
import 'dart:js' as js;

bool checkPWAInstallAvailable() {
  try {
    return js.context['pwaInstallAvailable'] as bool? ?? false;
  } catch (e) {
    return false;
  }
}

void installPWA() {
  try {
    js.context.callMethod('installPWA');
  } catch (e) {
    // Installation failed
  }
}
