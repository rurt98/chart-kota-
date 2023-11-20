import 'package:final_project_ba_char/styles/colors.dart';
import 'package:flutter/material.dart';

class PageTemplate extends StatefulWidget {
  final List<Widget>? actions;
  final Widget child;
  final String? title;
  final Widget? extraWidgetInTitle;
  final double? minHeight;
  final double? minWidth;
  final bool withSizedBoxInTitle;
  final bool scrollable;
  final Function()? onPressBack;

  final bool showTitle;

  const PageTemplate({
    super.key,
    required this.child,
    this.actions,
    this.minHeight,
    this.withSizedBoxInTitle = true,
    this.minWidth,
    this.onPressBack,
    this.title,
    this.extraWidgetInTitle,
    this.scrollable = false,
    this.showTitle = true,
  });

  @override
  State<PageTemplate> createState() => _PageTemplateState();
}

class _PageTemplateState extends State<PageTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (widget.showTitle)
            Padding(
              padding: const EdgeInsets.all(5).copyWith(
                left: 25,
              ),
              child: titleWidget(),
            ),
          Expanded(child: layout()),
        ],
      ),
    );
  }

  Widget layout() {
    final width = MediaQuery.of(context).size.width;

    if (widget.minWidth != null && width < widget.minWidth!) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: widget.minWidth,
          child: body(),
        ),
      );
    }

    return body();
  }

  Widget body() {
    final height = MediaQuery.of(context).size.height;

    if (widget.scrollable ||
        (widget.minHeight != null && height < widget.minHeight!)) {
      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(15).copyWith(
          top: 5,
          left: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: widget.minHeight,
              child: widget.child,
            ),
            const SizedBox(height: 15),
            footer(),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(15).copyWith(
        top: 5,
        left: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Expanded(child: widget.child),
          const SizedBox(height: 15),
          footer(),
        ],
      ),
    );
  }

  Widget titleWidget() {
    return Row(
      children: [
        if (widget.title != null)
          Expanded(
            child: Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: 20,
                    color: darkGreyApp,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        if (widget.onPressBack != null)
          BackButton(onPressed: widget.onPressBack),
        if (widget.withSizedBoxInTitle)
          const Expanded(
            child: SizedBox(),
          ),
        if (widget.actions != null) ...widget.actions!,
      ],
    );
  }

  Widget footer() {
    return Text(
      '2023 Crewip     Todos los derechos reservados  v1.0.0',
      style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: Colors.grey,
          ),
    );
  }
}
