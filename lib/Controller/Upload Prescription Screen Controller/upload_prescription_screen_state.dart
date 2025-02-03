import 'dart:io';


class UploadPrescriptionScreenState {
 File? selectedImage;
  final String? uploadedImageUrl;
  final bool isUploading;

  UploadPrescriptionScreenState({
    this.selectedImage,
    this.uploadedImageUrl,
    this.isUploading = false,
  });

  // Ensure the copyWith method updates the state correctly
  UploadPrescriptionScreenState copyWith({
    File? selectedImage,
    String? uploadedImageUrl,
    bool? isUploading,
  }) {

 
    return UploadPrescriptionScreenState(
      selectedImage: selectedImage ?? this.selectedImage,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}