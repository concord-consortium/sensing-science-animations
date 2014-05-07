var audio_icon_flasher;
var speedometer_flasher;

window.onload = function() {
  // initiate audio icon flashing
  audioIconFlasher('go');

  // set up event listener for when audio clip ends
  var audio_player = document.getElementById("audio1");
  audio_player.addEventListener('ended', loadNextAudioClip);
  // set up event listener for when audio clip plays
  audio_player.addEventListener('play', loadNextInstructionSet);

  // disable next page link
  disableNextLink();

  // begin speedometer flashing animation -- DISABLED FOR NOW
  //if (document.getElementById('red-speedometer')) {
    // set up event listener for when video clip ends
    //var video_player = document.getElementById("video-player");
    //video_player.addEventListener('ended', speedometerFlasher);
  //}

};

// controls changing the instructional text to match spoken audio when necessary
function loadNextInstructionSet() {
  var text = document.getElementById('text');
  if (!(typeof instructions_counter === 'undefined')) {
    text.innerHTML = '<p>' + instructions[instructions_counter] + '</p>';
    instructions_counter++;
  }
}

// controls animation of audio icon/link
function audioIconFlasher(action) {
  clearTimeout(audio_icon_flasher);
  document.getElementById('audio').onclick = playAudio;
  var audio_icon = document.getElementById('audio');
  if (action == 'stop') {
	audio_icon.style.opacity = 1;
  } else {
	if (audio_icon.style.opacity == 1 || audio_icon.style.opacity == '') {
	  audio_icon.style.opacity = .6;
	} else {
	  audio_icon.style.opacity = 1;
	}
	audio_icon_flasher = setTimeout("audioIconFlasher('go')", 400);
  }
}

// controls animation of speedometer flashing
function speedometerFlasher(action) {
  clearTimeout(speedometer_flasher);
  var red_speed = document.getElementById('red-speedometer');
  var blue_speed = document.getElementById('blue-speedometer');
  if (action == 'stop') {
    red_speed.style.opacity = 1;
    blue_speed.style.opacity = 1;
  } else {
    if (red_speed.style.opacity == 1 || red_speed.style.opacity == '') {
      red_speed.style.opacity = .8;
      blue_speed.style.opacity = .8;
    } else {
      red_speed.style.opacity = 1;
      blue_speed.style.opacity = 1;
    }
    speedometer_flasher = setTimeout("speedometerFlasher('go')", 600);
  }
}

// starts audio player
function playAudio() {
  document.getElementById('audio1').play();
  audioIconFlasher('stop');
  return false;
}

// loads next audio clip when appropriate and/or enables next page link
function loadNextAudioClip() {
  var audio_clips = ['a','b','c'];
  var audio_icon = document.getElementById('audio');
  var audio_clip = document.getElementById('audio1');
  audio_icon.style.opacity = .6;
  document.getElementById('audio').onclick = null;

  // get audio clip file name and number and letter from file name
  var audio_number, audio_letter, next_file;
  var audio_file = audio_clip.src.split(/(\\|\/)/g).pop();
  audio_number = audio_file.replace(/\w\.mp3$/g, '');
  audio_letter = audio_file.replace(/\.mp3$/g, '');
  audio_letter = audio_letter.replace(/^\d+/g, '');

  // load next clip if current clip isn't last
  if (audio_letter == 'a') {
    next_file = audio_number + 'b.mp3';
    audio_clip.src = 'audio/' + next_file;
    // wait ten seconds, then start flashing the audio icon
    audio_icon_flasher = setTimeout("audioIconFlasher('go')", 10000);
  } else if (audio_letter == 'b') {
    next_file = audio_number + 'c.mp3';
    audio_clip.src = 'audio/' + next_file;
    // wait ten seconds, then start flashing the audio icon
    audio_icon_flasher = setTimeout("audioIconFlasher('go')", 10000);
  } else {
    // enable next page link
    enableNextLink();
  }
}

// disables next page link
function disableNextLink() {
  var next_link = document.getElementById('right');
  next_link.style.opacity = .5;
  var href = next_link.getAttribute('href');
  next_link.setAttribute('href_bak', href);
  next_link.removeAttribute('href');
}

// enables next page link
function enableNextLink() {
  var next_link = document.getElementById('right');
  var href = next_link.getAttribute('href_bak');
  next_link.setAttribute('href', href);
  next_link.style.opacity = 1;
}

// check if files exists (not currently utilized, but may be useful in the future)
function fileExists(url) {
  var http = new XMLHttpRequest();
  http.open('HEAD', url, false);
  http.send();
  return http.status != 404;
}
