import 'dart:io';

class UploadPrescriptionScreenState {
  final File? selectedImage;
  final bool isUploading;
  final String? uploadedImageUrl;

  UploadPrescriptionScreenState({
    this.selectedImage,
    this.isUploading = false,
    this.uploadedImageUrl,
  });

  UploadPrescriptionScreenState copyWith({
    File? selectedImage,
    bool? isUploading,
    String? uploadedImageUrl,
  }) {
    return UploadPrescriptionScreenState(
      selectedImage: selectedImage ?? this.selectedImage,
      isUploading: isUploading ?? this.isUploading,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
    );
  }
}