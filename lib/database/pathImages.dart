import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PathImages {
  Future<void> saveImage(List<XFile> imagens) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String folderPath = '${directory.path}/imagens';

    for (var imagem in imagens) {
      String nome = imagem.name;
      String imagePath = '$folderPath/$nome';

      // Cria a pasta se ela não existir
      Directory(folderPath).createSync(recursive: true);

      // Copia a imagem para a pasta do aplicativo
      File imageFile = File(imagem.path);
      await imageFile.copy(imagePath);

      print("Imagem salva com sucesso em: $imagePath");
    }
  }
}
