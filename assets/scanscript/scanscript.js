// how much to pad before time jumps
const buffer = 3;
let filtered = false;
let transcript = document.querySelector('#transcript');

// Highlight Questions
let questions = [...document.querySelectorAll('#transcript p')].filter(e => e.innerHTML.includes('<strong>Q:</strong>'));
questions.forEach(q => q.classList = "question");
// Highlight Answers
let answers = [...document.querySelectorAll('#transcript p')].filter(e => e.innerHTML.includes('<strong>A:</strong>'));
answers.forEach(q => q.classList = "answer");
// Highlight Proper nounds
transcript.innerHTML = transcript.innerHTML.replace(/\[([^\]]+\])\.ppp/g,"<span class=\"proper\">$1</span>");
// Highlight Unclear audio
transcript.innerHTML = transcript.innerHTML.replace(/\[\.uuu(.*?\])/g,"<span class=\"unclear\">$1</span>");

// Audio player functions
var player = document.querySelector('#player audio');

// trap spacebar for play/pause
document.addEventListener('keypress', event => {
  if (event.code === 'Space') {
    event.preventDefault();
    if (player.paused) {
      player.play();
    } else {
      player.pause();
    }
    return false;
  }
})

const jump = (seconds) => {
  player.currentTime = seconds;
  player.play();
}

const stampToSeconds = (stamp) => {
  if (!(/^\d+:\d\d:\d\d$/).test(stamp)) {
      return null;
  }
  let hours, minutes, seconds;
  [hours, minutes, seconds] = stamp.split(/:/);
  seconds = Number(seconds);
  seconds += (Number(minutes) * 60);
  seconds += (Number(hours) * 60 * 60);
  // rewind 3 seconds
  return seconds - buffer;
}

// change all timestamps into links
const timestampReplacer = (match, p1, offset, string) => {
 let seconds = stampToSeconds(p1);
 return `[<a href="javascript:jump(${seconds})">${p1}</a>]`;
}

transcript.innerHTML = transcript.innerHTML.replace(/\[(\d+:\d\d:\d\d)\]/g, timestampReplacer);

const filterParagraphs = className => {
  if (filtered) {
    unfilterParagraphs();
    return;
  }
  unfilterParagraphs();
  let paras = document.querySelectorAll('#transcript p');
  let pArray = Array.from(paras);
  pArray.filter(p => !p.querySelector(`.${className}`)).forEach(p => p.classList.add('filtered'));
  filtered = true;
}

const unfilterParagraphs = () => {
  filtered = false;
  document.querySelectorAll('#transcript .filtered').forEach(p => p.classList.remove('filtered'));
}
