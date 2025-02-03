import 'dart:io';
import 'dart:developer';

class UploadPrescriptionScreenState {
  final File? selectedImage;
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

  log('copyWith called:');
  log('selectedImage: $selectedImage');
  log('uploadedImageUrl: $uploadedImageUrl');
  log('isUploading: $isUploading');
    return UploadPrescriptionScreenState(
      selectedImage: selectedImage ?? this.selectedImage,
      uploadedImageUrl: uploadedImageUrl ?? this.uploadedImageUrl,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}