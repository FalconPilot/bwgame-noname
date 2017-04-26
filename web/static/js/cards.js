/*
**  Rarity input listeners
*/

getName("rarity").forEach(function(node) {
  getTag("INPUT", node.parentNode)[0]
    .addEventListener("change", function() {
      let rarity = parseInt(getTag("INPUT", this.parentNode)[0].value);
      changeRarity(rarity);
    });
});

function changeRarity(rarity) {
  getName('rarity').forEach(function(star, i) {
    if (i < rarity) {
      star.innerHTML = "★";
    } else {
      star.innerHTML = "☆";
    }
  });
}

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
**  Card editing button
*/

getClass("edit-card").forEach(function(node) {
  node.addEventListener("click", function() {
    /* Instance variables */
    let form = getId("card-form");
    let wrapper = this.parentNode.parentNode;

    /* Define card values */
    let rarity = getClass("card-rarity", wrapper)[0].childNodes.length;
    let imgwrapper = getClass("img-wrapper", wrapper)[0];

    /* Modify form */
    getId("card_name").value = getTag("H2", wrapper)[0].textContent.trim();
    getId("card_group").value = getTag("H3", wrapper)[0].textContent.trim();
    getId("card_image").value = getStaticPath(getTag("IMG", imgwrapper)[0].src, "/images").trim();
    getId("card_description").value = getClass("card-desc", wrapper)[0].textContent.trim();
    getId("card_rarity_" + rarity).checked = true;

    /* Edit rarity display */
    changeRarity(rarity);
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

function addOverlay(overlayId, item) {
  /* Instance variables */
  let wrapper = item.parentNode.parentNode;
  let cid = getTag('input', wrapper)[0].value;

  /* Global overlay */
  let overlay = document.createElement('div');
  overlay.id = overlayId;
  overlay.className = 'flex-wrapper flex-col flex-stretch';
  overlay.name = item.name;

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
  userInput.addEventListener("input", function() {
    let btn = getId('append-btn');
    btn.href = "/giveto?cardid=" + btn.value + "&username=" + this.value;
  });

  /* Buttons header */
  let header = document.createElement('div');
  header.className = 'flex-wrapper flex-left';

  /* Append btn */
  let appendBtn = document.createElement('a');
  appendBtn.className = 'img-btn';
  appendBtn.id = "append-btn";
  appendBtn.innerHTML = "<img src='/images/gui/give-btn.png'>";
  appendBtn.value = cid;
  appendBtn.href = "/giveto?cardid=" + cid + "&username=";

  /* Close btn */
  let closeBtn = document.createElement('button');
  closeBtn.className = 'img-btn';
  closeBtn.innerHTML = "<img src='/images/gui/delete-btn.png'>";
  closeBtn.addEventListener('click', function() {
    let overlay = document.getElementById(overlayId);
    overlay.parentNode.removeChild(overlay);
  });

  /* Append children */
  main.appendChild(userLabel);
  main.appendChild(userInput);

  header.appendChild(appendBtn);
  header.appendChild(closeBtn);

  overlay.appendChild(header);
  overlay.appendChild(main);
  wrapper.appendChild(overlay);
}

/*
**  Get static path of an item
*/

function getStaticPath(url, first) {
  return (first + url.split(first)[1]);
}

/*
**  Get elements from selector
*/

function getClass(className, wrapper = document) {
  return [].slice.call(wrapper.getElementsByClassName(className));
}

function getName(name, wrapper = document) {
  return [].slice.call(wrapper.getElementsByName(name));
}

function getTag(tagName, wrapper = document) {
  return [].slice.call(wrapper.getElementsByTagName(tagName));
}

function getId(id, wrapper = document) {
  return wrapper.getElementById(id);
}

/*
**  Get page body
*/

function getBody() {
  return document.getElementsByTagName('BODY')[0];
}
