// Toggle submission status via AJAX
function toggleSubmission(checkbox, ideaId) {
  const newValue = checkbox.checked ? 1 : 0;
  const url = `/ideas/${ideaId}/toggle_submission`;
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
  
  fetch(url, {
    method: 'PATCH',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': csrfToken
    },
    body: JSON.stringify({ submission: newValue })
  })
  .then(response => {
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    return response.json();
  })
  .then(data => {
    const statusSpan = document.getElementById(`submission-status-${ideaId}`);
    if (statusSpan) {
      statusSpan.textContent = data.submission === 1 ? "提出済み ✓" : "未提出";
    }
  })
  .catch(error => {
    console.error('Error toggling submission:', error);
    // Revert checkbox on error
    checkbox.checked = !checkbox.checked;
  });
}

window.toggleSubmission = toggleSubmission;
