import 'dart:collection';
import 'dart:html';
import 'dart:math';

const int MAX_TEMPERATURE = 8000;
const int MAX_POINTS = 500;

final HtmlElement runButton = querySelector("#run_button");
final HtmlElement getLeftTemperatureButton = querySelector("#get_left_temperature");
final HtmlElement getRightTemperatureButton = querySelector("#get_right_temperature");
final VideoElement video = querySelector("#video-5");
final HtmlElement appletWindow = querySelector("#applet_window");
final HtmlElement leftArrow = querySelector("#red-speedometer-arrow");
final HtmlElement rightArrow = querySelector("#blue-speedometer-arrow");
final HtmlElement leftTemperatureText = querySelector("#left_temperature");
final HtmlElement rightTemperatureText = querySelector("#right_temperature");

Queue<double> _qLeft = new Queue<double>();
Queue<double> _qRight = new Queue<double>();

void main() {

  leftArrow.style.transformOrigin = "50% 100% 0";
  leftArrow.style.transform = "rotate(-90deg)";
  rightArrow.style.transformOrigin = "50% 100% 0";
  rightArrow.style.transform = "rotate(-90deg)";
  video.onEnded.listen((e) => _showApplet());
  
}

double getAverage(Queue q) {
  if(q.length == 0) return 0.0;
  double sum = 0.0;
  q.forEach((double e) {sum += e;} );
  return sum / q.length;  
}

void _loop(num delta) {

  // since we cannot directly communicate with Java from Dart, we are relying on JavaScript to do the job
  getLeftTemperatureButton.click();
  getRightTemperatureButton.click();

  // keep the latest segment of results
  _qLeft.addLast(double.parse(leftTemperatureText.innerHtml));
  _qRight.addLast(double.parse(rightTemperatureText.innerHtml));  
  if(_qLeft.length > MAX_POINTS) _qLeft.removeFirst();
  if(_qRight.length > MAX_POINTS) _qRight.removeFirst();

  double angle = 180.0 * getAverage(_qLeft) / MAX_TEMPERATURE - 90.0;
  angle = min(90.0, angle);
  angle = max(-90.0, angle);
  leftArrow.style.transformOrigin = "50% 100% 0";
  leftArrow.style.transform = "rotate(" + angle.toInt().toString() + "deg)";  

  angle = 180.0 * getAverage(_qRight) / MAX_TEMPERATURE - 90.0;
  angle = min(90.0, angle);
  angle = max(-90.0, angle);
  rightArrow.style.transformOrigin = "50% 100% 0";
  rightArrow.style.transform = "rotate(" + angle.toInt().toString() + "deg)";  

  window.animationFrame.then(_loop);

}

void _showApplet() {
  video.style.visibility = "hidden";
  appletWindow.style.visibility = "visible";
  runButton.click();
  window.animationFrame.then(_loop);
}
