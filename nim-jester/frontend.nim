# nim-universal/frontend.nim

import dom

proc sayHowdy() =
  let el = document.getElementById("app")
  el.innerHTML = "<h1>🤠 Howdy World from Nim!</h1>"

window.onload = sayHowdy