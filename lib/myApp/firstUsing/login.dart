import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Поле для электронной почты
            const TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'почта',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20), // Добавляем немного пространства
            // Поле для пароля
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'пароль',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20), // Добавляем немного пространства
            // Кнопка входа
            ElevatedButton(
              child: Text('Войти'),
              onPressed: () {
                // Обработка нажатия на кнопку
              },
            ),
            TextButton(
              child: Text('или зарегистрируйтесь здесь'),
              onPressed: () {

              },
            ),
            TextButton(
              child: Text('Войти как гость'),
              onPressed: () {
                // Обработка нажатия на текст для входа как гостя
              },
            ),
          ],
        ),
      ),
    );
  }
}