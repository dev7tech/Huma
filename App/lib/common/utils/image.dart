import 'package:hookup4u2/common/common.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

const kImageBucketBaseUrl = 'https://ghmpkmcrsedpizfwgcqr.supabase.co/storage/v1/object/public';

Future<String> uploadImage(XFile image) async {
  final fileName = '${Uuid().v4()}.${image.name.split('.').last}';
  final imgBytes = await image.readAsBytes();

  return supabaseClient.storage.from('images').uploadBinary(
        fileName,
        imgBytes,
      );
}
