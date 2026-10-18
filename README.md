# TENEFAR

Repositório oficial do projeto brasileiro **TENEFAR — Nutrição que transforma**.

Site e app de divulgação do projeto de Iniciação Científica (PIBIC/UTFPR)
**"Desenvolvimento de pó nutricional proteico à base de *Tenebrio molitor* para
suporte nutricional em casos de desnutrição aguda"**, com uma calculadora de
substituição proteica.

Feito em **Flutter** (Dart 3, Material 3). O alvo principal é a **web**
(publicada no GitHub Pages), e o mesmo código roda no **Android**.

## Páginas

| Rota           | Conteúdo                                                       |
| -------------- | -------------------------------------------------------------- |
| `/`            | Início: apresentação, destaques e status                       |
| `/projeto`     | Problema, vantagens do *T. molitor*, objetivos, ODS, resultados |
| `/metodologia` | Linha do tempo das 6 etapas e cronograma (Gantt)               |
| `/calculadora` | Calculadora de substituição proteica e necessidade diária      |
| `/equipe`      | Equipe e contato                                               |
| `/referencias` | Referências bibliográficas                                     |

## Como rodar

Pré-requisito: [Flutter](https://docs.flutter.dev/get-started/install) estável
(testado com 3.47.7).

```bash
flutter pub get
flutter run -d chrome     # web
flutter run               # Android (emulador ou celular conectado)
```

Verificações:

```bash
flutter analyze
flutter test
```

## Gerar a versão web

```bash
flutter build web --release --base-href /NOME_DO_REPOSITORIO/
```

O resultado fica em `build/web/`. Neste repositório o nome é `Tenefar`, então
`--base-href /Tenefar/`.

## Publicar no GitHub Pages

O workflow [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml) roda
`flutter analyze`, `flutter test`, faz o build e publica `build/web` a cada push
na branch `main`.

1. No GitHub, abra **Settings → Pages → Build and deployment** e escolha
   **Source: GitHub Actions**.
2. Faça push para a `main` (ou rode o workflow manualmente em **Actions**).
3. O site fica em `https://SEU_USUARIO.github.io/Tenefar/`.

O app usa URLs limpas (`/calculadora` em vez de `/#/calculadora`). Como o GitHub
Pages não conhece essas rotas, o workflow copia `index.html` para `404.html`:
assim, ao recarregar uma página ou abrir um link direto, o próprio app é
carregado e mostra a rota certa.

## Trocar o teor proteico da farinha

Edite [`lib/app/config.dart`](lib/app/config.dart):

```dart
static const double proteinaFarinhaPor100g = 50;   // ← valor medido (Kjeldahl)
static const bool valorProvisorio = true;          // ← false para esconder o aviso
static const double gramasColherSopaFarinha = 10;  // ← peso medido de 1 colher de sopa
```

Com `valorProvisorio = false`, o aviso de valor provisório some da calculadora.
O texto desse aviso está em `TextosCalculadora.avisoProvisorio`, em
[`lib/data/conteudo_projeto.dart`](lib/data/conteudo_projeto.dart).

## Adicionar alimentos

Em [`lib/data/alimentos.dart`](lib/data/alimentos.dart), acrescente uma linha na
categoria certa:

```dart
Alimento(
  id: 'grao-de-bico-cozido',          // único, minúsculas, sem acento
  nome: 'Grão-de-bico cozido',
  categoria: Categorias.leguminosas,
  proteinaPor100g: 0.0,               // g de proteína por 100 g (ou 100 ml)
  porcao: Porcao('2 colheres de sopa', 50), // opcional
),
```

Para líquidos, use `unidade: Unidade.ml`. Os testes verificam se os `id`s são
únicos, se nenhum valor é negativo e se a categoria existe.

## Onde trocar textos, cores e imagens

| O quê                                  | Onde                                                  |
| -------------------------------------- | ----------------------------------------------------- |
| Textos do projeto, equipe e referências | `lib/data/conteudo_projeto.dart`                      |
| Cores e fontes                         | `lib/app/theme.dart` (`Cores` e `_tipografia`)        |
| Constantes da calculadora              | `lib/app/config.dart`                                 |
| Logo da barra superior                 | `_Marca` em `lib/widgets/app_scaffold.dart`           |
| Ilustração da página inicial           | `_IlustracaoHero` em `lib/pages/inicio_page.dart`     |
| Logo/ícones                            | `assets/images/logo.svg` (origem), `web/icons/`, `web/favicon.png`, `android/app/src/main/res/mipmap-*/` |
| Título, descrição e Open Graph da web  | `web/index.html`                                      |

Nos textos, trechos entre `*asteriscos*` aparecem em itálico (use para nomes
científicos).

## Estrutura

```
lib/
  main.dart                 MaterialApp.router, tema, localização pt_BR
  app/        config.dart · router.dart · theme.dart
  data/       alimentos.dart · conteudo_projeto.dart
  models/     alimento.dart · item_refeicao.dart
  logic/      calculadora.dart (funções puras) · formatacao.dart
  state/      calculadora_controller.dart (Provider + ChangeNotifier)
  pages/      inicio · projeto · metodologia · calculadora · equipe · referencias · nao_encontrada
  widgets/    app_scaffold · secao · card_info · grade_responsiva · timeline_etapas ·
              gantt_cronograma · ods_card · resultado_card · busca_alimento ·
              texto_rico · entrada_animada
test/
  calculadora_test.dart         funções puras e base de dados
  widget_calculadora_test.dart  fluxo da calculadora
  responsivo_test.dart          todas as páginas em 360, 768 e 1280 px sem overflow
```

## Aviso

A calculadora compara apenas a quantidade de proteína e não substitui
orientação de nutricionista ou médico. O produto está em fase de pesquisa e
ainda não é destinado ao consumo.
