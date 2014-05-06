import 'dart:collection';
import 'dart:html';
import 'dart:math';

const int MAX_TEMPERATURE = 8000;
const int MAX_POINTS = 500;

class SSScreen {
  
  VideoElement video;
  HtmlElement runButton;
  HtmlElement keShadingOnButton;
  HtmlElement appletWindow;
  HtmlElement leftArrow;
  HtmlElement rightArrow;
  HtmlElement leftTemperatureText;
  HtmlElement rightTemperatureText;
  HtmlElement getLeftTemperatureButton;
  HtmlElement getRightTemperatureButton;
  
  // keep the latest segment of results in a queue
  Queue<double> _qLeft = new Queue<double>();
  Queue<double> _qRight = new Queue<double>();
  
  SSScreen(String videoName) {
  
    runButton = querySelector("#run_button");
    keShadingOnButton=querySelector("#keshading_on_button");
    appletWindow = querySelector("#applet_window");

    leftArrow = querySelector("#red-speedometer-arrow");
    rightArrow = querySelector("#blue-speedometer-arrow");
    leftArrow.style.transformOrigin = "50% 100% 0";
    leftArrow.style.transform = "rotate(-90deg)";
    rightArrow.style.transformOrigin = "50% 100% 0";
    rightArrow.style.transform = "rotate(-90deg)";

    leftTemperatureText = querySelector("#left_temperature");
    rightTemperatureText = querySelector("#right_temperature");
    getLeftTemperatureButton = querySelector("#get_left_temperature");
    getRightTemperatureButton = querySelector("#get_right_temperature");

    video = querySelector(videoName);
    video.onEnded.listen((e) => _showApplet());

  }
  
  void _loop(num delta) {

    // since we cannot directly communicate with Java from Dart, we are relying on JavaScript to do the job
    if(getLeftTemperatureButton != null) {
      getLeftTemperatureButton.click();
      _qLeft.addLast(double.parse(leftTemperatureText.innerHtml));
      if(_qLeft.length > MAX_POINTS) _qLeft.removeFirst();
      double angle = 180.0 * _getAverage(_qLeft) / MAX_TEMPERATURE - 90.0;
      angle = min(90.0, angle);
      angle = max(-90.0, angle);
      leftArrow.style.transformOrigin = "50% 100% 0";
      leftArrow.style.transform = "rotate(${angle.toInt()}deg)";
    }

    if(getRightTemperatureButton != null) {
      getRightTemperatureButton.click();
      _qRight.addLast(double.parse(rightTemperatureText.innerHtml));  
      if(_qRight.length > MAX_POINTS) _qRight.removeFirst();
      double angle = 180.0 * _getAverage(_qRight) / MAX_TEMPERATURE - 90.0;
      angle = min(90.0, angle);
      angle = max(-90.0, angle);
      rightArrow.style.transformOrigin = "50% 100% 0";
      rightArrow.style.transform = "rotate(${angle.toInt()}deg)";
    }

    window.animationFrame.then(_loop);

  }

  double _getAverage(Queue q) {
    if(q.length == 0) return 0.0;
    double sum = 0.0;
    q.forEach((double e) {sum += e;} );
    return sum / q.length;
  }

  void _showApplet() {
    video.style.visibility = "hidden";
    appletWindow.style.visibility = "visible";
    runButton.click();
    keShadingOnButton.click();
    window.animationFrame.then(_loop);
  }
  
}