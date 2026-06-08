# Design System Package

Biblioteca de componentes Flutter reutilizáveis seguindo a metodologia **Atomic Design** (Atoms, Molecules, Organisms) com suporte a temas e responsividade.

**Veja também**: [Controllers](../presentation/controllers.md) | [Arquitetura](../architecture/architecture-diagrams.md) | [Glossário](../glossary.md)

## Instalação

No `pubspec.yaml` do app principal ou pacote que consumirá o design system:

```yaml
dependencies:
  design_system:
    path: packages/design_system
```

## Importação

```dart
import 'package:design_system/design_system.dart';
```

---

## Índice de Componentes

### 🔹 Atoms (Átomos)

Componentes básicos e fundamentais.

| Componente              | Descrição                                                                                               |
| ----------------------- | ------------------------------------------------------------------------------------------------------- |
| `CheckboxWidget`        | Checkbox customizado com suporte a tema                                                                 |
| `AppIcon`               | Widget para ícones do app (SVG/PNG)                                                                     |
| `FlutterIcon`           | Wrapper para ícones do Flutter com tema                                                                 |
| `IconSize`              | Enum com tamanhos de ícones                                                                             |
| `CircularLoadingWidget` | Indicador de carregamento circular adaptativo                                                           |
| `SwitchWidget`          | Switch customizado (Cupertino)                                                                          |
| `TextWidget`            | Widget de texto com suporte a temas                                                                     |
| `TextRichWidget`        | Widget de texto rico com gestos                                                                         |
| `TextSize`              | Enum com tamanhos de fonte responsivos                                                                  |
| `AppTextStyle`          | Classes de estilo de texto (title, subtitle, message, error, label, field, button, hyperlink, footnote) |

---

### 🔸 Molecules (Moléculas)

Componentes compostos por átomos.

| Componente                 | Descrição                                 |
| -------------------------- | ----------------------------------------- |
| `FlatButton`               | Botão flat com ícone opcional             |
| `FutureButton`             | Botão com lógica assíncrona e loading     |
| `LightButton`              | Botão com fundo transparente              |
| `PrimaryButton`            | Botão primário do tema                    |
| `SecondaryButton`          | Botão secundário com borda                |
| `ToggleButton`             | Botão de alternância (toggle)             |
| `ButtonSize`               | Enum com tamanhos de botão responsivos    |
| `CheckboxTitleWidget`      | Checkbox com texto ao lado                |
| `BlurEffectWidget`         | Widget com efeito de desfoque             |
| `FloatingButtonWidget`     | Botão flutuante (FAB)                     |
| `IconButtonWidget`         | Botão de ícone                            |
| `ImageWidget`              | Widget de imagem com cache e fallback     |
| `TextFieldWidget`          | Campo de texto com diversas opções        |
| `TextAreaFieldWidget`      | Campo de texto multi-linha                |
| `PhoneFieldWidget`         | Campo de telefone com código do país      |
| `PinFieldWidget`           | Campo PIN com estilo customizado          |
| `AutoCompleteFieldWidget`  | Campo com autocomplete e busca assíncrona |
| `KeyboardVisibilityWidget` | Detecta visibilidade do teclado           |
| `ProgressBarWidget`        | Barra de progresso simples                |
| `ProgressStepBarWidget`    | Barra de progresso em etapas              |
| `SkeletonWidget`           | Widget de esqueleto para loading          |
| `SwitchTitleWidget`        | Switch com texto ao lado                  |

---

### 🔶 Organisms (Organismos)

Componentes complexos compostos por molecules e atoms.

| Componente                      | Descrição                                        |
| ------------------------------- | ------------------------------------------------ |
| `AppBarWidget`                  | AppBar customizada com suporte a actions e popup |
| `AppBarSearchDelegate`          | Delegate para busca na AppBar                    |
| `BottomSheetWidget`             | Bottom sheet com configurações customizadas      |
| `PasswordValidationBottomSheet` | Bottom sheet para validação de senha             |
| `Captcha`                       | Classe abstrata para exibir captcha              |
| `CaptchaWidget`                 | Widget de captcha local                          |
| `DialogWidget`                  | Diálogos: erro, escolha, modal, captcha          |
| `DrawerWebWidget`               | Drawer para web                                  |
| `SearchModalWidget`             | Modal de busca                                   |
| `BottomNavigatorWidget`         | Navegação inferior com observáveis               |
| `NavigatorRouterWidget`         | Router com navegação aninhada (GetX)             |
| `NavigatorItem`                 | Classe para itens de navegação                   |
| `NavigatorBottom`               | Classe para itens da bottom bar                  |
| `ScaffoldWidget`                | Scaffold com suporte a blur, pop gesture e GetX  |
| `ScrollViewWidget`              | Scroll com Scrollbar personalizado               |
| `ScrollStateWidget`             | Widget com estados de loading/error/empty (Rx)   |
| `ScrollStateNotifierWidget`     | Widget com estados usando ValueNotifier          |
| `SnackBarWidget`                | SnackBar customizada                             |

---

### 🛠 Helpers (Ajudantes)

| Classe                 | Descrição                            |
| ---------------------- | ------------------------------------ |
| `ResponsiveSizeHelper` | Utilitário para tamanhos responsivos |
| `SpacerWidget`         | Espaçador responsivo                 |

---

### 📄 Pages (Páginas)

| Componente                | Descrição                             |
| ------------------------- | ------------------------------------- |
| `ErrorPage`               | Página de erro genérica               |
| `PermissionRequestWidget` | Página para solicitação de permissões |
| `SplashContentWidget`     | Conteúdo da splash screen             |
| `UnknownPage`             | Página para rotas desconhecidas       |

---

### 📐 Templates

| Classe    | Descrição                              |
| --------- | -------------------------------------- |
| `AppView` | Classe abstrata base para views (GetX) |

---

### 🎨 Tokens (Design Tokens)

| Categoria  | Descrição                                                               |
| ---------- | ----------------------------------------------------------------------- |
| **Colors** | Cores, esquemas e temas de cores (`AppColor`, `AppColorScheme`)         |
| **Const**  | Assets e famílias de fontes                                             |
| **Themes** | Gerenciamento de temas claro/escuro (`ThemeController`, `ThemeManager`) |

---

## Exemplos de Uso

### Exemplo 1: Botão Primário

```dart
PrimaryButton(
  label: 'Entrar',
  onPressed: () {
    // ação do botão
  },
)
```

### Exemplo 2: Campo de Texto

```dart
TextFieldWidget(
  label: 'E-mail',
  hintText: 'Digite seu e-mail',
  keyboardType: TextInputType.emailAddress,
  validator: EmailValidator(),
)
```

### Exemplo 3: AppBar Customizada

```dart
AppBarWidget(
  title: TextWidget.title('Minha Página'),
  actions: [
    IconButtonWidget(
      icon: AppIcon(Icons.settings),
      onPressed: () {},
    ),
  ],
)
```

### Exemplo 4: Switch com Título

```dart
SwitchTitleWidget(
  title: 'Receber notificações',
  value: true,
  onChanged: (value) {
    // atualizar estado
  },
)
```

### Exemplo 5: Diálogo de Erro

```dart
DialogWidget.error(
  context: context,
  message: 'Ocorreu um erro inesperado.',
  onConfirm: () {
    // ação de confirmar
  },
)
```

### Exemplo 6: Scaffold com Bottom Navigation

```dart
ScaffoldWidget(
  appBar: AppBarWidget(title: TextWidget.title('Home')),
  body: ScrollViewWidget(
    child: Column(
      children: [
        TextWidget.title('Bem-vindo!'),
        SpacerWidget(),
        PrimaryButton(
          label: 'Começar',
          onPressed: () {},
        ),
      ],
    ),
  ),
  bottomNavigationBar: BottomNavigatorWidget(
    items: [
      NavigatorItem(icon: Icons.home, label: 'Home'),
      NavigatorItem(icon: Icons.person, label: 'Perfil'),
    ],
  ),
)
```

### Exemplo 7: Texto com Estilos Predefinidos

```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    TextWidget.title('Título Principal'),
    TextWidget.subtitle('Subtítulo da página'),
    TextWidget.message('Esta é uma mensagem informativa.'),
    TextWidget.error('Erro: campo obrigatório'),
    TextWidget.label('Campo de entrada'),
    TextWidget.button('TEXTO DO BOTÃO'),
    TextWidget.hyperlink('Clique aqui para saiba mais'),
    TextWidget.footnote('Rodapé pequeno'),
  ],
)
```

### Exemplo 8: Progress Bar

```dart
ProgressBarWidget(
  value: 0.6,
  backgroundColor: Colors.grey[300],
  valueColor: AppColor.primary,
)
```

### Exemplo 9: Checkbox com Título

```dart
CheckboxTitleWidget(
  title: 'Aceito os termos de uso',
  value: false,
  onChanged: (value) {
    // atualizar estado
  },
)
```

### Exemplo 10: Loading Circular

```dart
CircularLoadingWidget(
  color: AppColor.primary,
  size: IconSize.medium,
)
```

---

## Validação de Inputs

O design system inclui validadores prontos para campos de formulário:

| Validador                  | Descrição                    |
| -------------------------- | ---------------------------- |
| `EmailValidator`           | Valida formato de e-mail     |
| `PasswordValidator`        | Valida força da senha        |
| `ConfirmPasswordValidator` | Confirma se senhas coincidem |
| `NameValidator`            | Valida nome completo         |
| `NotEmptyValidator`        | Campo obrigatório            |
| `UrlValidator`             | Valida formato de URL        |

Exemplo de uso com TextFieldWidget:

```dart
TextFieldWidget(
  label: 'Senha',
  obscureText: true,
  validator: PasswordValidator(),
)
```

---

## Gerenciamento de Tema

O design system suporta temas claro e escuro via `ThemeController`:

```dart
// Verificar tema atual
final isDark = ThemeController.isDarkMode;

// Alternar tema
ThemeController.toggleTheme();
```

---

## Estrutura de Pastas

```
packages/design_system/
├── lib/
│   ├── design_system.dart        # Barrel file principal
│   └── src/
│       ├── components/           # Atoms, Molecules, Organisms
│       │   ├── atoms/
│       │   ├── molecules/
│       │   └── organisms/
│       ├── helpers/              # Utilitários
│       ├── pages/               # Páginas prontas
│       ├── templates/            # Templates base
│       └── tokens/              # Design tokens (cores, temas)
└── test/                         # Testes
```

---

## Dependências

- `flutter/material.dart`
- `get` (GetX para gerenciamento de estado)
- Demais pacotes internos: `core`, `dependency`, `clean_code_domain`

---

## Licença

Consulte o arquivo LICENSE na raiz do projeto.
