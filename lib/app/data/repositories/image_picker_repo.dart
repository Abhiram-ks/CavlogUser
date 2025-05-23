
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/usecases/image_picker_usecase.dart';



class ImagePickerRepositoryImpl implements ImagePickerRepository {
  final ImagePicker _imagePicker;

  ImagePickerRepositoryImpl(this._imagePicker);

  @override
  Future<String?> pickImage() async {
    final PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      return image?.path;
    } else {
      await openAppSettings();
      return null;
    }
  }
}
