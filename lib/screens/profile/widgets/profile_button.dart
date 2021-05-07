import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/screens/edit_profile/edit_profile_screen.dart';
import 'package:flutter_instagram_clone/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileButton extends StatelessWidget {
  final bool isCurrentUser;
  final bool isFollowing;

  const ProfileButton({
    Key key,
    @required this.isCurrentUser,
    @required this.isFollowing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.lightBlue)),
            onPressed: () => Navigator.of(context).pushNamed(
              EditProfileScreen.routeName,
              arguments: EditProfileScreenArgs(context: context),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          )
        : TextButton(
            style: ButtonStyle(
                backgroundColor: isFollowing
                    ? MaterialStateProperty.all<Color>(Colors.grey[300])
                    : MaterialStateProperty.all<Color>(Colors.lightBlue)),
            onPressed: () => isFollowing
                ? context.read<ProfileBloc>().add(ProfileUnfollowUser())
                : context.read<ProfileBloc>().add(ProfileFollowUser()),
            child: Text(isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                    fontSize: 16.0,
                    color: isFollowing ? Colors.black : Colors.white)),
          );
  }
}
