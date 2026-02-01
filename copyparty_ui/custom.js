document.addEventListener("DOMContentLoaded", () => {
  if (document.getElementById("dl-brand")) return;

  const a = document.createElement("a");
  a.id = "dl-brand";
  a.href = "/";
  a.title = "Deeplight";

  const img = document.createElement("img");
  img.src = "/ui/Deeplight_Logo_Blue_RGB.png";
  img.alt = "Deeplight";
  a.appendChild(img);

  // Try to attach to a header-like container first
  const candidates = [
    document.querySelector("header"),
    document.querySelector("#header"),
    document.querySelector("#top"),
    document.querySelector("#nav"),
    document.querySelector(".top"),
    document.querySelector(".header"),
    document.body
  ];

  const target = candidates.find(Boolean);
  target.prepend(a);
});
