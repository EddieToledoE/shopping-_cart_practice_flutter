import 'package:http/http.dart' as http;

class LoginResult {
  final bool success;
  final String message;

  LoginResult({required this.success, required this.message});
}

class ExternalAuthService {
  Future<LoginResult> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("https://backendm-t.onrender.com/login"),
        body: {"usuario": email, "contra": password},
      );

      final responseBody = response.body;

      if (response.statusCode == 200) {
        if (responseBody.contains("Inicio de sesión exitoso")) {
          return LoginResult(
            success: true,
            message: "Inicio de sesión exitoso",
          );
        } else if (responseBody.contains("No deje campos vacíos")) {
          return LoginResult(success: false, message: "No deje campos vacíos");
        } else if (responseBody.contains(
          "Nombre de usuario o contraseña incorrectos",
        )) {
          return LoginResult(
            success: false,
            message: "Nombre de usuario o contraseña incorrectos",
          );
        } else {
          return LoginResult(
            success: false,
            message: "Respuesta no esperada del servidor",
          );
        }
      } else {
        return LoginResult(
          success: false,
          message: "Error en el servidor (${response.statusCode})",
        );
      }
    } catch (e) {
      return LoginResult(
        success: false,
        message: "Error de conexión o servidor: $e",
      );
    }
  }
}
