[].slice.call(document.getElementsByName('rarity')).forEach(function(node) {
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

[].slice.call(document.getElementsByClassName('card-rarity')).forEach(function(node) {
  let rarity = parseInt(node.innerHTML);
  node.innerHTML = "";
  for (let i = 0; i < rarity; i++) {
    let block = document.createElement('p');
    block.innerHTML = "★";
    node.appendChild(block);
  }
});
