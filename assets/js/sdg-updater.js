function updateSdgs() {
  // If the URL contains "/stats/", do not run this function.
  if (window.location.href.indexOf('/stats/') !== -1) {
    return;
  }

  window.loadedDataPromise
    .then(jsonData => {
      // Get the SDG counts from the parsed JSON data.
      const sdgCounts = jsonData.menu.sdgs;

      // Helper function: animate the counter from start to end over the specified duration (in ms).
      function animateValue(element, start, end, duration) {
        let startTimestamp = null;
        const step = (timestamp) => {
          if (!startTimestamp) startTimestamp = timestamp;
          const progress = Math.min((timestamp - startTimestamp) / duration, 1);
          element.textContent = Math.floor(progress * (end - start) + start);
          if (progress < 1) {
            window.requestAnimationFrame(step);
          }
        };
        window.requestAnimationFrame(step);
      }

      // Loop over each SDG number. Assuming the first array element corresponds to #sdg1, etc.
      sdgCounts.forEach((targetCount, index) => {
        const sdgIndex = index + 1; // Array index starts at 0, but our IDs are 1-based.
        const sdgElement = document.getElementById('sdg' + sdgIndex);
        if (sdgElement) {
          // Find the <span> that holds the publication count.
          const countElement = sdgElement.querySelector('.sdg-publication-count span');
          if (countElement) {
            // On hover, animate from the current number to the target count.
            sdgElement.addEventListener('mouseenter', function () {
              // Parse the current number; if not a number, default to 0.
              const currentCount = parseInt(countElement.textContent) || 0;
              animateValue(countElement, currentCount, targetCount, 250);
            });
          }
        }
      });
    })
    .catch(error => {
      console.error('Error fetching or processing SDG data:', error);
    });
}
