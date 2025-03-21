document.addEventListener('DOMContentLoaded', () => {
    const uploadForm = document.getElementById('uploadForm');
    const fileInput = document.getElementById('fileInput');
    const uploadStatus = document.getElementById('uploadStatus');

    uploadForm.addEventListener('submit', async (event) => {
        event.preventDefault();

        const file = fileInput.files[0];
        if (!file) {
            uploadStatus.textContent = 'Please select a file.';
            uploadStatus.style.color = 'red';
            return;
        }

        const formData = new FormData();
        formData.append('file', file);

        try {
            uploadStatus.textContent = 'Uploading...';
            uploadStatus.style.color = 'black';

            const response = await fetch('http://localhost:3001/upload', {
                method: 'POST',
                body: formData,
            });

            if (response.ok) {
                uploadStatus.textContent = 'File uploaded successfully!';
                uploadStatus.style.color = 'green';
                uploadForm.reset();
            } else {
                const errorMessage = await response.text();
                uploadStatus.textContent = `Upload failed: ${errorMessage}`;
                uploadStatus.style.color = 'red';
            }
        } catch (error) {
            console.error('Error uploading file:', error);
            uploadStatus.textContent = 'An error occurred during upload.';
            uploadStatus.style.color = 'red';
        }
    });
});