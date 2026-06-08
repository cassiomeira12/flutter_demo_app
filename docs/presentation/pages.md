# Presentation Page (AppView)

## Visão Geral

Pages no Flutter Demo App usam `AppView<T>` do `design_system`, que estende `GetView<T>` do GetX. O `AppView` resolve automaticamente o controller via `AppBinding.find<T>()`, eliminando a necessidade de chamar `Get.find()` manualmente.

## Definição

```dart
abstract class AppView<T extends BaseController> extends GetView<T> {
  const AppView({super.key});

  @override
  T get controller => AppBinding.find<T>(tag: tag);
}
```

- O `controller` é injetado automaticamente via `AppBinding.find()`
- O tipo `T` deve estender `BaseController` (ou `LifecycleController`)

## Padrão de Nomenclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Page | Sufixo `Page` | `SecurityPage`, `SplashPage`, `HomePage` |

## Estrutura Padrão

```dart
import 'package:dependency/dependency.dart';
import 'package:design_system/design_system.dart';
import 'package:feature_name/src/presentation/feature_name/feature_name.dart';

class FeatureNamePage extends AppView<FeatureNameController> {
  const FeatureNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'feature_title'.tr,
      body: // conteúdo da página
    );
  }
}
```

## Componentes do Design System

| Widget | Uso |
|--------|-----|
| `ScaffoldWidget` | Estrutura base da página (app bar, body, loading, empty, error states) |
| `ScrollViewWidget` | Scroll customizado com header e footer |
| `CircularLoadingWidget` | Indicador de loading |
| `TextWidget` | Texto estilizado |
| `TextWidget.error` | Texto de erro |
| `SwitchTitleWidget` | Toggle com título |
| `SpacerWidget` | Espaçamento vertical |
| `DialogWidget` | Diálogos |
| `PrimaryButton` | Botão primário |
| `TextFieldWidget` | Campo de texto |
| `NavigatorRouterWidget` | Navegação por abas (bottom navigation) |
| `ResponsiveSizeHelper` | Helpers de tamanho responsivo |
| `AppTextStyle` | Estilos de texto |
| `AppColors` | Cores do tema |

## Exemplos

### Página Simples

```dart
class SplashPage extends AppView<SplashController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      hideAppBar: true,
      body: const SplashContentWidget(),
    );
  }
}
```

### Página com Loading e Estado Reativo

```dart
class SecurityPage extends AppView<SecurityController> {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      controller: controller,
      title: 'security'.tr,
      body: ScrollViewWidget(
        child: (scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(ResponsiveSizeHelper.width(0)),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const CircularLoadingWidget();
                }
                return Column(
                  spacing: ResponsiveSizeHelper.spacingDefaultHeight * 2,
                  children: [
                    Obx(() {
                      return SwitchTitleWidget(
                        initialValue: controller.biometric.value,
                        text: controller.biometric.value
                            ? 'biometric_enabled'.tr
                            : 'biometric_disabled'.tr,
                        textStyle: AppTextStyle.field(context),
                        onChanged: controller.toggleBiometric,
                      );
                    }),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
```

### Página com Navegação por Abas

```dart
class HomePage extends AppView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      title: Platform.isWeb ? 'Home' : null,
      hideAppBar: !Platform.isWeb,
      controller: Platform.isWeb ? controller : null,
      body: NavigatorRouterWidget(
        initialIndex: HomePage.initialIndex,
        pages: pages,
        selectedIndex: controller.selectedIndex,
        changeTab: controller.changeTab,
        bottomItems: bottomItems,
      ),
    );
  }
}
```

## Regras

1. **Construtor**: Sempre `const XxxPage({super.key})`
2. **Controller**: Acessado via getter `controller` (herdado de `AppView`)
3. **Widget base**: Usar `ScaffoldWidget` como container principal
4. **Reatividade**: Usar `Obx(() => ...)` para estado `Rx` do controller
5. **Traduções**: Strings com `.tr` (GetX internationalization)
6. **Sem lógica**: Pages não devem conter lógica de negócio — apenas delegar para o controller
7. **Imports**:
   - `package:dependency/dependency.dart` para `Obx`
   - `package:design_system/design_system.dart` para `AppView`, `ScaffoldWidget`, etc.

## Checklist para Criar uma Nova Page

- [ ] Nome segue padrão `NomeFeaturePage`
- [ ] Estende `AppView<NomeFeatureController>`
- [ ] Construtor `const` com `{super.key}`
- [ ] Usa `ScaffoldWidget` como container
- [ ] Controller acessado via getter `controller`
- [ ] Estado reativo com `Obx`
- [ ] Strings traduzidas com `.tr`
- [ ] Sem lógica de negócio na Page
- [ ] Importa `package:dependency/dependency.dart` e `package:design_system/design_system.dart`

---

**Veja também**: [Controllers](controllers.md) | [Bindings](bindings.md) | [Design System](../design-system/README.md)
