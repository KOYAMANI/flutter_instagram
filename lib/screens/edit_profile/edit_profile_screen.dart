import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram_clone/models/models.dart';
import 'package:flutter_instagram_clone/repositories/repositories.dart';
import 'package:flutter_instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_instagram_clone/widgets/error_dialog.dart';
import 'package:flutter_instagram_clone/widgets/widgtes.dart';

import 'cubit/edit_profile_cubit.dart';

class EditProfileScreenArgs {
  final BuildContext context;

  const EditProfileScreenArgs({@required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/editProfile';

  static Route route({@required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
        create: (_) => EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfileScreen(
            user: args.context.read<ProfileBloc>().state.user),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User user;

  EditProfileScreen({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  if (state.status == EditProfileStatus.submitting)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 32.0),
                  GestureDetector(
                    onTap: () => _selectProfileImage(context),
                    child: UserProfileImage(
                      radius: 80.0,
                      profileImageUrl: user.profileImageUrl,
                      profileImage: state.profileImage,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            initialValue: user.username,
                            decoration: InputDecoration(hintText: 'Username'),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .usernameChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Username cannot be empty.'
                                : null,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: user.bio,
                            decoration: InputDecoration(hintText: 'Bio'),
                            onChanged: (value) => context
                                .read<EditProfileCubit>()
                                .bioChanged(value),
                            validator: (value) => value.trim().isEmpty
                                ? 'Bio cannot be empty.'
                                : null,
                          ),
                          const SizedBox(height: 28.0),
                          ElevatedButton(
                            onPressed: () => _submitForm(
                              context,
                              state.status == EditProfileStatus.submitting,
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.lightBlue)),
                            child: const Text(
                              'Update',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {}

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }
}
