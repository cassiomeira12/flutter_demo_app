import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/scheduler.dart';

class AutoCompleteFieldWidget<T extends Object> extends StatefulWidget {
  final Key? customKey;
  final bool fetchOnInit;
  final String? label;
  final String? hintText;
  final TextEditingValue? initialSelectedValue;
  final Future<List<T>> Function(String? query, int? take, int? skip) items;
  final String Function(Object item) getName;
  final String? suggestText;
  final List<T> suggestItems;
  final ValueChanged<Object?> onSelected;
  final String emptyResultMessage;
  //final PageInfoEntity pageInfo;
  final bool hideSuggestions;
  final GestureTapCallback? onTap;
  final bool applyCamelCase;
  final Widget Function(BuildContext context, T item)? itemBuilder;

  AutoCompleteFieldWidget({
    super.key,
    this.customKey,
    this.label,
    this.fetchOnInit = true,
    this.hintText,
    required this.items,
    required this.getName,
    this.suggestText,
    this.suggestItems = const [],
    required this.onSelected,
    this.initialSelectedValue,
    this.emptyResultMessage =
        'Não foi possível encontrar um resultado de busca.',
    //required this.pageInfo,
    this.hideSuggestions = false,
    this.onTap,
    this.applyCamelCase = true,
    this.itemBuilder,
  }) {
    if (!hideSuggestions) {
      assert(suggestItems.isNotEmpty, 'Suggest Items must not be Empty');
    }
  }

  @override
  State<AutoCompleteFieldWidget> createState() =>
      _AutoCompleteFieldWidgetState<T>();
}

class _AutoCompleteFieldWidgetState<T extends Object>
    extends State<AutoCompleteFieldWidget> {
  late TextEditingController _textController;
  late ScrollController controller;

  final List<Object> _listItems = [];
  bool _loadingList = true;
  bool _showSuggestions = true;
  String? _errorMessage;
  // int _skip = 30;

  bool acceptListener = false;
  bool initialized = false;

  Timer? _multipleIgnoreCallsTimer;

  final int _delayTime = 2000;

  TextEditingValue? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialSelectedValue;
    _loadingList = _selectedValue != null;
    if (widget.fetchOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fetchListItems(null, null, null);
      });
    }
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _textController.dispose();
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500) {
      // if (widget.pageInfo.hasNextPage) {
      //   _fetchListItems(null, 30, _skip += _skip);
      // }
    }
  }

  Future<void> _fetchListItems(String? query, int? take, int? skip) async {
    setState(() => _loadingList = true);
    await widget.items
        .call(query, take, skip)
        .then((items) {
          if (query == _textController.text) {
            setState(() {
              _listItems.clear();
              _listItems.addAll(items);
              _errorMessage = null;
            });
          }
        })
        .catchError((error) {
          if (query == _textController.text) {
            setState(() => _errorMessage = error.toString());
          }
        })
        .whenComplete(() {
          setState(() {
            _loadingList = false;
            if (_textController.text.isEmpty) {
              _showSuggestions = true;
            }
          });
        });
  }

  void _setSelectedItem(T? item) {
    widget.onSelected(item);
    if (item == null) {
      setState(() {
        _selectedValue = null;
        _loadingList = false;
      });
    } else {
      _textController.text = widget.applyCamelCase
          ? widget.getName(item) //.toCamelCase()
          : widget.getName(item);
      setState(() {
        _selectedValue = TextEditingValue(text: _textController.text);
        _loadingList = false;
        _showSuggestions = false;
        _errorMessage = null;
      });
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  bool isTheSelected(T item) {
    return (_selectedValue?.text ?? '') ==
        (widget.applyCamelCase
            ? widget.getName(item) //.toCamelCase()
            : widget.getName(item));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(
        maxWidth: ResponsiveSizeHelper.maxWidth,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Autocomplete<T>(
            displayStringForOption: (T item) => widget.getName(item),
            onSelected: (T item) => _setSelectedItem(item),
            initialValue: _selectedValue,
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  _textController = controller;
                  initialized = true;
                  return TextFieldWidget(
                    label: widget.label,
                    customKey: widget.customKey,
                    focusNode: focusNode,
                    controller: _textController,
                    hintText: widget.hintText,
                    // enabledChangeBorderColor: false,
                    onTap: widget.onTap,
                    onTapOutside: () {
                      if (_textController.text != _selectedValue?.text) {
                        _setSelectedItem(null);
                      }
                    },
                    suffixIcon: _showSuggestions
                        ? AppIcon(
                            AppIcons.bell,
                            //key: const Key('search_icon'),
                            //GuideIcons.search,
                            //width: 24,
                            //height: 24,
                            color: theme.primaryColor,
                          )
                        : GestureDetector(
                            child: AppIcon(
                              AppIcons.bell,
                              //key: const Key('clear_text'),
                              //GuideIcons.close,
                              //color: GuideColors.colorPrimaryLightVar1,
                              color: theme.primaryColor,
                            ),
                            onTap: () {
                              controller.clear();
                              _setSelectedItem(null);
                              setState(() {
                                _showSuggestions = true;
                              });
                            },
                          ),
                    onChanged: (value) {
                      if (_errorMessage != null) {
                        setState(() {
                          _errorMessage = null;
                          _loadingList = true;
                        });
                      }
                      if (value.isNotEmpty) {
                        acceptListener = true;
                        setState(() {
                          _showSuggestions = false;
                          _loadingList = true;
                        });
                        if (_multipleIgnoreCallsTimer?.isActive ?? false) {
                          _multipleIgnoreCallsTimer?.cancel();
                        }
                        _multipleIgnoreCallsTimer = Timer(
                          Duration(milliseconds: _delayTime),
                          () {
                            if (!mounted) return;
                            if (acceptListener) {
                              acceptListener = false;
                              _fetchListItems(value, 30, 0);
                            }
                          },
                        );
                      } else {
                        _fetchListItems(null, null, null);
                        _setSelectedItem(null);
                        setState(() {
                          _showSuggestions = true;
                        });
                      }
                    },
                  );
                },
            optionsViewBuilder: (context, onSelected, items) {
              if (_loadingList) {
                return const SizedBox.shrink();
              }
              if (_errorMessage != null) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: AppColors.statusWarning,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: ResponsiveSizeHelper.maxWidth,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSizeHelper.width(10),
                        vertical: ResponsiveSizeHelper.height(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            key: Key('error_message'),
                            'Ocorreu um erro, tente novamene.',
                            textAlign: TextAlign.center,
                            // style: GuideTextStyle.body3R(
                            //   color: GuideColors.colorSecondaryVar3Lightest,
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              final result = _listItems
                  .where((item) {
                    return widget
                        .getName(item)
                        .toLowerCase()
                        .contains(_textController.text.trim().toLowerCase());
                  })
                  .toSet()
                  .map((item) => item as T);
              if (result.isEmpty) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: theme.primaryColor,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: ResponsiveSizeHelper.maxWidth,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSizeHelper.width(10),
                        vertical: ResponsiveSizeHelper.height(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextWidget(
                            widget.emptyResultMessage,
                            textAlign: TextAlign.center,
                            // style: const GuideTextStyle.body3R(
                            //   color: GuideColors.colorPrimaryLightVar2,
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: theme.primaryColor,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: ResponsiveSizeHelper.maxWidth,
                      maxHeight: ResponsiveSizeHelper.maxHeight * .3,
                    ),
                    child: ScrollViewWidget(
                      child: (scrollController) {
                        return ListView.separated(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: result.length,
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 0,
                              thickness: 1,
                              color: theme.canvasColor,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final T item = result.elementAt(index);
                            return InkWell(
                              onTap: () => onSelected(item),
                              child: Builder(
                                builder: (BuildContext context) {
                                  final bool highlight =
                                      AutocompleteHighlightedOption.of(
                                        context,
                                      ) ==
                                      index;
                                  if (highlight) {
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((
                                          Duration timeStamp,
                                        ) {
                                          Scrollable.ensureVisible(
                                            context,
                                            alignment: 0.5,
                                          );
                                        });
                                  }
                                  return widget.itemBuilder?.call(
                                        context,
                                        item,
                                      ) ??
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal:
                                              ResponsiveSizeHelper.width(10),
                                          vertical: ResponsiveSizeHelper.height(
                                            10,
                                          ),
                                        ),
                                        color: theme.primaryColor,
                                        margin: const EdgeInsets.only(
                                          bottom: 2,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: TextWidget(
                                                // widget.applyCamelCase ? widget.getName(item).toCamelCase() : widget.getName(item),
                                                widget.getName(item),
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                                overflow: TextOverflow.ellipsis,
                                                // style: GuideTextStyle.subtitle2R(
                                                //   color: isTheSelected(item)
                                                //       ? GuideColors.colorPrimaryLightVar1
                                                //       : GuideColors.colorNeutralLight,
                                                // ),
                                              ),
                                            ),
                                            AppIcon(
                                              AppIcons.bell,
                                              // isTheSelected(item)
                                              //     ? Icons.radio_button_on
                                              //     : Icons.radio_button_off,
                                              // color: isTheSelected(item)
                                              //     ? GuideColors.colorPrimaryLightVar1
                                              //     : GuideColors.colorNeutralLight,
                                              // size: 16,
                                            ),
                                          ],
                                        ),
                                      );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text == '') {
                _setSelectedItem(null);
                return const Iterable.empty();
              }
              return widget.suggestItems.map((item) => item as T);
            },
          ),
          if (_loadingList && _selectedValue == null ||
              (initialized &&
                  _loadingList &&
                  _selectedValue?.text != _textController.text))
            _buildLoading(context),
          const SpacerWidget(),
          if (_showSuggestions && !widget.hideSuggestions)
            Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  [
                    if (widget.suggestText != null) widget.suggestText,
                    ...widget.suggestItems.map((item) => widget.getName(item)),
                    //.toList(),
                  ].asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () {
                        if (widget.suggestText == null) {
                          _setSelectedItem(widget.suggestItems[entry.key] as T);
                        } else {
                          if (entry.key > 0) {
                            _setSelectedItem(
                              widget.suggestItems[entry.key - 1] as T,
                            );
                          }
                        }
                      },
                      child: Container(
                        color: theme.primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveSizeHelper.width(10),
                          vertical: ResponsiveSizeHelper.height(10),
                        ),
                        margin: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: TextWidget(
                                entry.value!,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                // style: entry.key > 0
                                //     ? const GuideTextStyle.subtitle2R(
                                //         color: GuideColors.colorNeutralWhite,
                                //       )
                                //     : const GuideTextStyle.subtitle3R(
                                //         color: GuideColors.colorNeutralLight,
                                //       ),
                              ),
                            ),
                            // Visibility(
                            //   visible: entry.key > 0,
                            //   child: Icon(
                            //     (_selectedValue?.text ?? '') ==
                            //             entry.value.toString().toCamelCase()
                            //         ? Icons.radio_button_on
                            //         : Icons.radio_button_off,
                            //     color: (_selectedValue?.text ?? '') ==
                            //             entry.value.toString().toCamelCase()
                            //         ? GuideColors.colorPrimaryLightVar1
                            //         : GuideColors.colorNeutralLight,
                            //     size: 16,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        color: AppColors.transparent,
        child: Container(
          margin: EdgeInsets.only(top: ResponsiveSizeHelper.height(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: CircularLoadingWidget(
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
