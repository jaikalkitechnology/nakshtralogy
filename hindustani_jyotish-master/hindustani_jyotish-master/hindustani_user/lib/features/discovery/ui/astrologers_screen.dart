import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hj_core/hj_core.dart';

import '../../../core/di.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/responsive.dart';
import '../../../shared/widgets/astrologer_card.dart';
import '../../consultation/consult_actions.dart';
import '../astrologers_cubit.dart';
import '../discovery_repository.dart';

/// Common filter options. The backend accepts free-form strings, so these are
/// convenience presets; the search box remains the escape hatch for anything
/// not listed here.
const List<String> _languageOptions = [
  'Hindi',
  'English',
  'Bengali',
  'Tamil',
  'Telugu',
  'Marathi',
  'Gujarati',
  'Punjabi',
  'Kannada',
  'Malayalam',
  'Odia',
  'Urdu',
];

const List<String> _skillOptions = [
  'Vedic',
  'Tarot',
  'Numerology',
  'Vastu',
  'Palmistry',
  'KP',
  'Nadi',
  'Lal Kitab',
  'Prashna',
  'Horary',
  'Face Reading',
];

class AstrologersScreen extends StatelessWidget {
  const AstrologersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AstrologersCubit>(
      create: (_) => AstrologersCubit(getIt<DiscoveryRepository>())..load(),
      child: const _AstrologersView(),
    );
  }
}

class _AstrologersView extends StatefulWidget {
  const _AstrologersView();

  @override
  State<_AstrologersView> createState() => _AstrologersViewState();
}

class _AstrologersViewState extends State<_AstrologersView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      context.read<AstrologersCubit>().loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) context.read<AstrologersCubit>().setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CenteredMaxWidth(
        child: BlocBuilder<AstrologersCubit, AstrologersState>(
          builder: (context, state) {
            final cubit = context.read<AstrologersCubit>();
            final f = state.filters;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context).navAstrologers,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.display(size: 24),
                        ),
                      ),
                      _SortMenu(value: f.sort, onChanged: cubit.setSort),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: _SearchField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onClear: () {
                      _searchController.clear();
                      _debounce?.cancel();
                      cubit.setSearch('');
                    },
                  ),
                ),
                _FilterBar(state: state, cubit: cubit),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.saffron,
                    onRefresh: cubit.refresh,
                    child: _Body(state: state, controller: _scrollController),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.body(size: 14),
      decoration: InputDecoration(
        isDense: true,
        hintText: AppLocalizations.of(context).discoverySearchHint,
        hintStyle: AppTextStyles.body(size: 14, color: AppColors.ivoryFaint),
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.ivoryDim,
          size: 20,
        ),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.ivoryDim,
                  ),
                  onPressed: onClear,
                ),
        ),
        filled: true,
        fillColor: AppColors.surface1,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderSoft),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.saffron),
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.state, required this.cubit});
  final AstrologersState state;
  final AstrologersCubit cubit;

  @override
  Widget build(BuildContext context) {
    final f = state.filters;
    final l = AppLocalizations.of(context);
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          FilterChip(
            label: Text(l.discoveryOnlineNow),
            avatar: Icon(
              Icons.circle,
              size: 10,
              color: f.onlineOnly ? AppColors.success : AppColors.ivoryFaint,
            ),
            selected: f.onlineOnly,
            onSelected: cubit.setOnlineOnly,
            backgroundColor: AppColors.surface1,
            selectedColor: AppColors.saffron.withValues(alpha: 0.20),
            side: const BorderSide(color: AppColors.borderSoft),
            labelStyle: AppTextStyles.label(size: 12, color: AppColors.ivory),
          ),
          const SizedBox(width: 8),
          _SelectChip(
            label: l.discoveryLanguage,
            value: f.language,
            options: _languageOptions,
            onSelected: cubit.setLanguage,
          ),
          const SizedBox(width: 8),
          _SelectChip(
            label: l.discoverySkill,
            value: f.skill,
            options: _skillOptions,
            onSelected: cubit.setSkill,
          ),
          if (f.activeCount > 0) ...[
            const SizedBox(width: 8),
            ActionChip(
              avatar: Icon(
                Icons.clear_all,
                size: 16,
                color: AppColors.ivoryDim,
              ),
              label: Text(l.commonClear),
              onPressed: cubit.clearFilters,
              backgroundColor: AppColors.surface2,
              side: const BorderSide(color: AppColors.borderSoft),
              labelStyle: AppTextStyles.label(
                size: 12,
                color: AppColors.ivoryDim,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A chip that reflects a single-select filter and opens a bottom sheet of
/// [options] on tap. Selecting the active option again clears it.
class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.value,
    required this.options,
    required this.onSelected,
  });
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onSelected;

  Future<void> _open(BuildContext context) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.indigoDeep,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(label, style: AppTextStyles.heading(size: 16)),
            ),
            for (final o in options)
              ListTile(
                title: Text(o, style: AppTextStyles.body(size: 14)),
                trailing: value == o
                    ? const Icon(Icons.check, color: AppColors.saffron)
                    : null,
                onTap: () => Navigator.pop(context, o),
              ),
          ],
        ),
      ),
    );
    if (selected != null) {
      onSelected(selected == value ? null : selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = value != null;
    return InputChip(
      label: Text(active ? value! : label),
      selected: active,
      onPressed: () => _open(context),
      onDeleted: active ? () => onSelected(null) : null,
      deleteIcon: active ? const Icon(Icons.close, size: 16) : null,
      avatar: active
          ? null
          : Icon(Icons.expand_more, size: 18, color: AppColors.ivoryDim),
      backgroundColor: AppColors.surface1,
      selectedColor: AppColors.saffron.withValues(alpha: 0.20),
      side: const BorderSide(color: AppColors.borderSoft),
      labelStyle: AppTextStyles.label(size: 12, color: AppColors.ivory),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.state, required this.controller});
  final AstrologersState state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final list = state.astrologers;
    if (list == null) {
      if (state.error != null) {
        return _ScrollMessage(
          text: state.error!,
          color: AppColors.danger,
          icon: Icons.error_outline,
        );
      }
      return const Center(
        child: CircularProgressIndicator(color: AppColors.saffron),
      );
    }
    if (list.isEmpty) {
      return _ScrollMessage(
        text: AppLocalizations.of(context).discoveryNoMatch,
        color: AppColors.ivoryFaint,
        icon: Icons.search_off,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = Responsive.gridColumns(constraints.maxWidth);
        final showFooter = state.loadingMore || !state.hasMore;
        return GridView.builder(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 246,
          ),
          itemCount: list.length + (showFooter ? columns : 0),
          itemBuilder: (context, index) {
            if (index >= list.length) {
              // Footer cells: show a spinner in the first, blanks in the rest.
              if (index == list.length && state.loadingMore) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.saffron),
                );
              }
              if (index == list.length && !state.hasMore) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context).discoveryReachedEnd,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.label(
                      size: 12,
                      color: AppColors.ivoryFaint,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }
            final a = list[index];
            return AstrologerCard(
              astrologer: a,
              onTap: () => context.push('/astrologers/${a.id}'),
              onChat: () =>
                  startConsultation(context, a.id, ConsultationType.chat),
              onCall: () =>
                  startConsultation(context, a.id, ConsultationType.call),
              onVideo: () =>
                  startConsultation(context, a.id, ConsultationType.video),
            );
          },
        );
      },
    );
  }
}

class _ScrollMessage extends StatelessWidget {
  const _ScrollMessage({
    required this.text,
    required this.color,
    required this.icon,
  });
  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 120),
        Icon(icon, size: 48, color: color.withValues(alpha: 0.6)),
        const SizedBox(height: 16),
        Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.body(color: color),
          ),
        ),
      ],
    );
  }
}

class _SortMenu extends StatelessWidget {
  const _SortMenu({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final labels = {
      'top_rated': l.discoverySortTopRated,
      'price_asc': l.discoverySortPriceAsc,
      'price_desc': l.discoverySortPriceDesc,
    };
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      color: AppColors.indigoDeep,
      tooltip: l.discoverySort,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSoft),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sort, color: AppColors.ivoryDim, size: 18),
            const SizedBox(width: 6),
            Text(
              labels[value] ?? l.discoverySort,
              style: AppTextStyles.label(size: 12, color: AppColors.ivory),
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        for (final e in labels.entries)
          PopupMenuItem(value: e.key, child: Text(e.value)),
      ],
    );
  }
}
