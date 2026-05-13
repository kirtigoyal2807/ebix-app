import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pilates_app/core/localization/localization_extension.dart';
import 'package:pilates_app/features/loyalty/data/loyalty_repository.dart';
import 'package:pilates_app/widgets/app_app_bar.dart';

import 'badge_collection_body.dart';
import 'cubit/badge_cubit.dart';

class BadgeCollectionView extends StatelessWidget {
  const BadgeCollectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BadgeCubit(context.read<LoyaltyRepository>())..load(),
      child: Scaffold(
        appBar: AppAppBar(
          title: context.l10n.badge_collection,
          onBack: () => Navigator.of(context).pop(),
          isMoreMenu: false,
        ),
        body: const BadgeCollectionBody(),
      ),
    );
  }
}
