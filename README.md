# TENEFAR

Repositório oficial do projeto brasileiro **TENEFAR — Nutrição que transforma**.

Site e app de divulgação do projeto de Iniciação Científica (PIBIC/Unioeste)
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
| Textos do projeto, contato e referências | `lib/data/conteudo_projeto.dart`                    |
| Cores e fontes                         | `lib/app/theme.dart` (`Cores` e `_tipografia`)        |
| Constantes da calculadora              | `lib/app/config.dart`                                 |
| Logo (emblema e completa)              | `assets/images/logo_emblema.png` e `logo_completo.png` (PNG transparente, pintado pela cor do tema) |
| Ícones do app e favicon                | `web/icons/`, `web/favicon.png`, `android/app/src/main/res/mipmap-*/` |
| Imagem de compartilhamento             | `web/og-image.png`                                    |
| Título, descrição e Open Graph da web  | `web/index.html`                                      |

Nos textos, trechos entre `*asteriscos*` aparecem em itálico (use para nomes
científicos).

## Identidade visual

- **Cores:** tinta `#1A2C30` (a cor da logo) e papel `#F3EFE6` como cores
  principais, e um único destaque ocre `#E3A22E` ("farinha dourada").
- **Tipografia:** Fraunces (títulos, pesos leves e itálico de ênfase),
  Instrument Sans (texto) e IBM Plex Mono (rótulos, dados e números).
- **Layout:** coluna lateral de rótulos numerados (estilo caderno de
  laboratório), muito espaço negativo e índice editorial no lugar de cards.
- **Micro-interações:** o marca-texto ocre risca a palavra-chave ao aparecer,
  os números da calculadora contam até o resultado, as linhas do índice
  reagem ao hover e o ponto de "em andamento" pulsa algumas vezes. Todas são
  desligadas quando o sistema pede menos animação.

## Estrutura

```
lib/
  main.dart                 MaterialApp.router, tema, localização pt_BR
  app/        config.dart · router.dart · theme.dart
  data/       alimentos.dart · conteudo_projeto.dart
  models/     alimento.dart · item_refeicao.dart
  logic/      calculadora.dart (funções puras) · formatacao.dart
  state/      calculadora_controller.dart (Provider + ChangeNotifier)
  pages/      inicio · projeto · metodologia · calculadora · referencias · nao_encontrada
  widgets/    app_scaffold · secao · indice · interacao · marca_texto · logo ·
              grade_responsiva · timeline_etapas · gantt_cronograma · ods_card ·
              resultado_card · busca_alimento · texto_rico · entrada_animada
test/
  calculadora_test.dart         funções puras e base de dados
  widget_calculadora_test.dart  fluxo da calculadora
  responsivo_test.dart          todas as páginas em 360, 768 e 1280 px sem overflow
```

## Aviso

A calculadora compara apenas a quantidade de proteína e não substitui
orientação de nutricionista ou médico. O produto está em fase de pesquisa e
ainda não é destinado ao consumo.
