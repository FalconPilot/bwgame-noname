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

let newClose = getId('newcard-close');
if (newClose) {
  getBody().style.overflow = 'hidden';
  newClose.addEventListener('click', function() {
    getBody().style.overflow = null;
    let wrapper = this.parentNode.parentNode;
    wrapper.parentNode.removeChild(wrapper);
  });
}

/*
**  Card overlay toggle button
*/

getName("overlay-toggle").forEach(function(btn) {
  btn.addEventListener("click", function() {
    toggleOverlay(getStaticPath(this.href, "#").substr(1));
  });
});

/*
**  Append overlay
*/

function toggleOverlay(overlayId) {
  let overlay = getId(overlayId);
  /* Overlay exist */
  if (overlay) {
    if (overlay.style.display) {
      overlay.style.display = null;
    } else {
      overlay.style.display = 'none';
    }
  /* Overlay doesn't exist */
  } else {
    console.log("Error : Overlay " + overlayId + " doesn't exist")
  }
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
