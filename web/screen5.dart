import 'dart:html';

final HtmlElement runButton = querySelector("#run_button");
final VideoElement video = querySelector("#video-5");
final HtmlElement appletWindow = querySelector("#applet_window");

void main() {

  video.onEnded.listen((e) => _showApplet());
  
}

void _showApplet() {
  video.style.visibility = "hidden";
  appletWindow.style.visibility = "visible";
  runButton.click();
}
