/*
**  Rarity input listeners
*/

getName("rarity").forEach(function(node) {
  node
    .parentNode
    .getElementsByTagName('INPUT')[0]
    .addEventListener("click", function() {
      let rarity = parseInt(this.parentNode.getElementsByTagName('INPUT')[0].value);
      [].slice.call(document.getElementsByName('rarity')).forEach(function(star, i) {
        if (i < rarity) {
          star.innerHTML = "★";
        } else {
          star.innerHTML = "☆";
        }
      });
    });
});

/*
**  Card rarity display
*/

getClass("card-rarity").forEach(function(node) {
  let rarity = parseInt(node.innerHTML);
  node.innerHTML = "";
  for (let i = 0; i < rarity; i++) {
    let block = document.createElement('p');
    block.innerHTML = "★";
    node.appendChild(block);
  }
});

/*
**  Card giving buttons
*/

getClass("give-card").forEach(function(node) {
  node.addEventListener("click", function() {
    /* Instance variables */
    let overlayId = "overlay-give-card";
    let win = document.getElementById(overlayId);
    /* If overlay exist */
    if (win) {
      win.parentNode.removeChild(win);
      if (this.name !== win.name) {
        addOverlay(overlayId, this);
      }
    /* If overlay doesn't exist */
    } else {
      addOverlay(overlayId, this);
    }
  });
});

/*
**  Newcard notice close button
*/

let newClose = document.getElementById('newcard-close');
if (newClose) {
  getBody().style.overflow = 'hidden';
  newClose.addEventListener('click', function() {
    getBody().style.overflow = null;
    let wrapper = this.parentNode.parentNode;
    wrapper.parentNode.removeChild(wrapper);
  });
}

/*
**  Append overlay
*/

function addOverlay(overlayId, wrapper) {
  /* Global overlay */
  let overlay = document.createElement('div');
  overlay.id = overlayId;
  overlay.className = 'flex-wrapper flex-col flex-stretch';
  overlay.name = wrapper.name;

  /* Wrapping div */
  let main = document.createElement('div');
  main.className = 'flex-wrapper flex-col flex-1';

  /* User input label */
  let userLabel = document.createElement('label');
  userLabel.className = "label-white";
  userLabel.innerHTML = "Utilisateur";

  /* User input */
  let userInput = document.createElement('input');
  userInput.className = 'standard-input';

  /* Buttons footer */
  let footer = document.createElement('div');
  footer.className = 'flex-wrapper flex-right';

  /* Append btn */
  let appendBtn = document.createElement('a');
  appendBtn.className = 'standard-btn card-btn';
  appendBtn.innerHTML = '⬋';
  appendBtn.href = "/giveto?cardid="

  /* Close btn */
  let closeBtn = document.createElement('button');
  closeBtn.className = 'standard-btn card-btn';
  closeBtn.innerHTML = "x";
  closeBtn.addEventListener('click', function() {
    let overlay = document.getElementById(overlayId);
    overlay.parentNode.removeChild(overlay);
  });

  /* Append children */
  main.appendChild(userLabel);
  main.appendChild(userInput);

  footer.appendChild(appendBtn);
  footer.appendChild(closeBtn);

  overlay.appendChild(main);
  overlay.appendChild(footer);
  wrapper.parentNode.parentNode.appendChild(overlay);
}

/*
**  Get elements from selector
*/

function getClass(className) {
  return [].slice.call(document.getElementsByClassName(className));
}

function getName(name) {
  return [].slice.call(document.getElementsByName(name));
}

/*
**  Get page body
*/

function getBody() {
  return document.getElementsByTagName('BODY')[0];
}
