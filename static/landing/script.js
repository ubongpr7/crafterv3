// const slides = document.querySelectorAll(".slide");
// const dots = document.querySelectorAll(".dot");
// let currentIndex = 0;

// function showSlide(index) {
//   const offset = -index * 100;
//   document.querySelector(".slides").style.transform = `translateX(${offset}%)`;

//   dots.forEach((dot, i) => {
//     dot.classList.toggle("active", i === index);
//   });
// }

// dots.forEach((dot, index) => {
//   dot.addEventListener("click", () => {
//     currentIndex = index;
//     showSlide(index);
//   });
// });

// // Automatically cycle through slides
// setInterval(() => {
//   currentIndex = (currentIndex + 1) % slides.length;
//   showSlide(currentIndex);
// }, 3000); // Change every 3 seconds




function initializeSlider(sliderClass) {
  const slider = document.querySelector(sliderClass);
  const slides = slider.querySelectorAll(".slide");
  const dots = slider.querySelectorAll(".dot");
  let currentIndex = 0;

  function showSlide(index) {
    const offset = -index * 100;
    slider.querySelector(".slides").style.transform = `translateX(${offset}%)`;
    dots.forEach((dot, i) => {
      dot.classList.toggle("active", i === index);
    });
  }

  dots.forEach((dot, index) => {
    dot.addEventListener("click", () => {
      currentIndex = index;
      showSlide(index);
    });
  });

  // Automatically cycle through slides
  // setInterval(() => {
  //   currentIndex = (currentIndex + 1) % slides.length;
  //   showSlide(currentIndex);
  // }, 3000); // Change every 3 seconds
}

// Initialize each slider individually
initializeSlider(".tiktok-slider");
initializeSlider(".facebook-slider");
initializeSlider(".youtube-slider");


document.addEventListener("DOMContentLoaded", () => {
  const lazyVideos = document.querySelectorAll("video.lazy");

  if ("IntersectionObserver" in window) {
    const observer = new IntersectionObserver((entries, observer) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const video = entry.target;
          video.src = video.dataset.src;
          video.load();
          video.classList.remove("lazy");
          observer.unobserve(video);
        }
      });
    });

    lazyVideos.forEach(video => observer.observe(video));
  } else {
    // Fallback for older browsers
    lazyVideos.forEach(video => {
      video.src = video.dataset.src;
      video.load();
      video.classList.remove("lazy");
    });
  }
});
