import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../category_model.dart';
import 'profile_edit_page.dart';
import 'category_edit_page.dart';
import '../app_colors.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.blueWhite,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.only(top: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ваш профиль',
                    style: TextStyle(
                      color: AppColors.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditPage(),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: const Icon(
                        Icons.settings,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Ваши категории',
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 18,
                ),
              ),
            ),
            Consumer<CategoryModel>(
              builder: (context, categoryModel, child) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                categoryModel.categories.length,
                                    (index) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    categoryModel.categories[index],
                                    style: const TextStyle(
                                      color: AppColors.darkBlue,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryEditPage(),
                                ),
                              ).then((_) {
                                Provider.of<CategoryModel>(context, listen: false).notifyListeners();
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.darkBlue),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(
                                Icons.edit,
                                color: AppColors.darkBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Ваш прогресс привычек',
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 18,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: List.generate(
                  3,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Привычка ${index + 1}',
                          style: const TextStyle(
                            color: AppColors.darkBlue,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: (index + 1) / 3,
                          backgroundColor: AppColors.blueWhite,
                          color: AppColors.darkBlue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}