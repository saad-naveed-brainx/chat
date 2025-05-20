import 'package:chatme/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import '../core/constants/view_constants.dart';
import '../viewmodels/create_user_viewmodel.dart';
import 'package:provider/provider.dart';

class CreateUserProfile extends StatefulWidget {
  const CreateUserProfile({super.key});

  @override
  State<CreateUserProfile> createState() => _CreateUserProfileState();
}

class _CreateUserProfileState extends State<CreateUserProfile> {
  late final CreateUserViewModel _viewModel = CreateUserViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.checkUser(context);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<CreateUserViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text(ViewConstants.createUserProfile)),
            ),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Form(
                      key: viewModel.formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.gap20Px,
                          vertical: AppConstants.gap10Px,
                        ),
                        child: TextFormField(
                          controller: viewModel.nameController,
                          validator: viewModel.nameValidator,
                          onTapOutside: (_) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            hintText: ViewConstants.enterYourName,
                            filled: true,
                            fillColor: Colors.grey[100],
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.blue,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.gap14Px,
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.gap14Px,
                              ),
                              borderSide: BorderSide(
                                color: Colors.blue.shade200,
                                width: AppConstants.gap2Px,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: AppConstants.gap14Px,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.gap20Px,
                      ),
                      child: ElevatedButton(
                        onPressed:
                            viewModel.isLoading
                                ? null
                                : () => viewModel.validateAndSave(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.gap24Px * 2,
                            vertical: AppConstants.gap14Px,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.gap14Px * 2,
                            ),
                          ),
                          elevation: 5,
                          shadowColor: Colors.blue.withOpacity(0.5),
                        ),
                        child:
                            viewModel.isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Text(
                                  ViewConstants.startChatting,
                                  style: TextStyle(
                                    fontSize: AppConstants.gap14Px,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
