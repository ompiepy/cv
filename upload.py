import os
from azure.storage.blob import BlobServiceClient, BlobClient, ContentSettings

def upload_pdf_to_azure_blob(pdf_file_path, connection_string, container_name, blob_name):
    try:
        # Create a BlobServiceClient using the connection string
        blob_service_client = BlobServiceClient.from_connection_string(connection_string)

        # Get a BlobClient for the PDF file within the existing container
        blob_client = blob_service_client.get_blob_client(container_name, blob_name)

        # Set the Content-Type for the PDF file
        content_settings = ContentSettings(content_type="application/pdf")

        # Upload the PDF file
        with open(pdf_file_path, "rb") as data:
            blob_client.upload_blob(data, overwrite=True, content_settings=content_settings)

        print(f"Uploaded {pdf_file_path} to Azure Blob Storage as {blob_name}")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

if __name__ == "__main__":
    pdf_file_path = "./cv.pdf"  # Path to the PDF file you want to upload
    connection_string = os.environ.get('CONNECTION_STRING')  # Your Azure Blob Storage connection string
    container_name = "$web"  # The name of the existing container in Azure Blob Storage
    blob_name = "cv.pdf"  # The name you want to give to the PDF file in Azure Blob Storage

    upload_pdf_to_azure_blob(pdf_file_path, connection_string, container_name, blob_name)