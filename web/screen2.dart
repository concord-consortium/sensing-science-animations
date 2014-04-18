import 'dart:html';
import 'dart:math';

final HtmlElement runButton = querySelector("#run_button");
final HtmlElement getRightTemperatureButton = querySelector("#get_right_temperature");
final VideoElement video = querySelector("#video-2");
final HtmlElement appletWindow = querySelector("#applet_window");
final HtmlElement leftArrow = querySelector("#red-speedometer-arrow");
final HtmlElement rightArrow = querySelector("#blue-speedometer-arrow");
final HtmlElement rightTemperatureText = querySelector("#right_temperature");

double rightTemperature;
double angle;
const int _MAX_TEMPERATURE = 8000;

void main() {

  leftArrow.style.transformOrigin = "50% 100% 0";
  leftArrow.style.transform = "rotate(-90deg)";
  rightArrow.style.transformOrigin = "50% 100% 0";
  rightArrow.style.transform = "rotate(-90deg)";
  video.onEnded.listen((e) => _showApplet());
  
}

void _loop(num delta) {
  // since we cannot directly communicate with Java from Dart, we are relying on JavaScript to do the job
  getRightTemperatureButton.click();
  rightTemperature = double.parse(rightTemperatureText.innerHtml);
  angle = 180.0 * rightTemperature / _MAX_TEMPERATURE - 90.0;
  angle = min(90.0, angle);
  angle = max(-90.0, angle);
  rightArrow.style.transformOrigin = "50% 100% 0";
  rightArrow.style.transform = "rotate(" + angle.toInt().toString() + "deg)";  
  window.animationFrame.then(_loop);
}

void _showApplet() {
  rightArrow.style.transformOrigin = "50% 100% 0";
  rightArrow.style.transform = "rotate(-30deg)";
  video.style.visibility = "hidden";
  appletWindow.style.visibility = "visible";
  runButton.click();
  window.animationFrame.then(_loop);
}
