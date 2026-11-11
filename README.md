# Mobility+ — Mobilidade inclusiva para todos

**Global Solution FIAP | Aplicativo Mobile | Flutter e Dart**

## 1. Sobre o projeto

O **Mobility+** é um aplicativo mobile desenvolvido em Flutter e Dart, com foco em acessibilidade e mobilidade urbana inclusiva.

O projeto busca facilitar a mobilidade de pessoas com deficiência ou com necessidades específicas de deslocamento, oferecendo informações sobre locais, recursos de acessibilidade e possibilidades de planejamento de trajetos.

A proposta é contribuir para uma cidade mais inclusiva, permitindo que os usuários pesquisem estabelecimentos, consultem informações disponíveis e considerem suas necessidades de mobilidade antes de realizar um deslocamento.

### Tema da Global Solution

**Acessibilidade Inclusiva — Mobilidade sem barreiras.**

## 2. Objetivos da solução

- Facilitar a busca por estabelecimentos e locais de interesse.
- Disponibilizar informações geográficas por meio de uma API REST.
- Incentivar a consulta e o compartilhamento de informações sobre acessibilidade.
- Oferecer uma interface intuitiva e organizada.
- Considerar diferentes necessidades de mobilidade e acessibilidade.

O Mobility+ não classifica automaticamente um estabelecimento como acessível. As informações disponíveis devem ser verificadas, pois a ausência de dados não significa necessariamente ausência de recursos de acessibilidade.

## 3. Tecnologias utilizadas

| Tecnologia | Finalidade |
|---|---|
| Flutter | Desenvolvimento da interface mobile |
| Dart | Linguagem de programação |
| Material Design | Componentes visuais |
| go_router | Navegação entre telas |
| http | Requisições HTTP |
| SharedPreferences | Persistência local de preferências |
| OpenStreetMap / Nominatim | Consulta de locais e informações geográficas |

## 4. Funcionalidades e telas

### 4.1 Splash Screen
- Apresentação da identidade visual do Mobility+.
- Transição automática para a próxima tela.
- Verificação da preferência de exibição do onboarding utilizando SharedPreferences.

### 4.2 Onboarding
- Introdução à proposta do aplicativo.
- Apresentação em três páginas.
- Botões para avançar e voltar.
- Opção "Não mostrar novamente".
- Salvamento da preferência do usuário.

### 4.3 Menu principal

O aplicativo possui navegação principal com quatro áreas:

- **Início:** apresentação e acesso às funcionalidades.
- **Locais:** pesquisa de estabelecimentos e consulta de informações.
- **Rotas:** área destinada ao planejamento de deslocamentos.
- **Perfil:** acesso às informações e preferências do usuário.

### 4.4 Locais
- Pesquisa de locais por nome ou endereço.
- Consulta de dados utilizando a API OpenStreetMap/Nominatim.
- Exibição dos resultados na interface.
- Acesso à tela de detalhes.
- Opção de favoritar e desfavoritar locais.
- Atualização dos resultados.
- Tratamento de carregamento, sucesso, lista vazia e erro.

### 4.5 Detalhes do local
- Exibição do nome e categoria.
- Endereço e coordenadas disponíveis.
- Consulta de informações relacionadas à acessibilidade, quando existentes.
- Identificação da origem dos dados.

### 4.6 Rotas
Área destinada à experiência de planejamento de deslocamentos acessíveis.

### 4.7 Perfil e acessibilidade
- Acesso às preferências de acessibilidade.
- Personalização da experiência.
- Consulta das informações do perfil.

### 4.8 Relatos de barreiras
Área destinada ao preenchimento de informações sobre barreiras encontradas no ambiente urbano.

**Observação:** funcionalidades que dependem de autenticação, persistência em servidor, envio de relatos e cálculo efetivo de rotas dependem de integrações adicionais e não devem ser consideradas concluídas enquanto não estiverem implementadas e testadas.

## 5. API REST utilizada

**Serviço:** Nominatim — OpenStreetMap

**Endpoint:**
`https://nominatim.openstreetmap.org/search`

**Método HTTP:** GET

**Parâmetros utilizados:**
- `q`: termo pesquisado.
- `format=jsonv2`: formato da resposta.
- `addressdetails=1`: inclusão de informações de endereço.
- `extratags=1`: inclusão de tags adicionais.
- `limit=20`: limite de resultados solicitados.

### Implementação

- Serviço responsável pelas requisições: `lib/services/api_service.dart`.
- Modelo responsável pela representação dos dados: `lib/models/place.dart`.
- Conversão da resposta JSON para objetos Dart: `Place.fromNominatim`.

### Tratamento dos estados

A tela de locais contempla os seguintes estados:

- **Inicial:** antes do carregamento.
- **Carregamento:** durante a requisição HTTP.
- **Sucesso:** quando os dados são recebidos.
- **Lista vazia:** quando não existem resultados para a pesquisa.
- **Erro:** quando ocorre uma falha na requisição, com mensagem e opção de tentar novamente.

### Limitações da API

O Nominatim fornece dados geográficos e informações colaborativas do OpenStreetMap. Esses dados não garantem que um estabelecimento possua condições adequadas de acessibilidade.

A ausência de uma marcação não comprova a ausência de acessibilidade. Da mesma forma, a presença de uma informação deve ser confirmada antes da visita.

A utilização do serviço deve respeitar sua política de uso e seus limites de requisições.

## 6. Fluxo de navegação

```text
Splash
  |
  v
Onboarding (3 páginas)
  |
  v
Escolha de acesso
  |
  +----> Explorar sem conta
  |
  +----> Login
  |
  +----> Cadastro
             |
             v
  Personalização de acessibilidade
             |
             v
         Início
             |
    +--------+--------+--------+
    |        |        |        |
    v        v        v        v
  Início   Locais   Rotas    Perfil
             |
             v
      Detalhes do local
```

As telas secundárias possuem acesso ao início por meio do botão com ícone de casa. O menu principal também permite alternar entre Início, Locais, Rotas e Perfil.

## 7. Arquitetura e organização do projeto

O projeto está organizado em diretórios para separar as responsabilidades da aplicação.

```text
mobility_plus/
│
├── android/
├── assets/
│   └── images/
│
├── lib/
│   ├── app/
│   │   ├── app.dart
│   │   └── router.dart
│   │
│   ├── models/
│   │   ├── accessibility_profile.dart
│   │   └── place.dart
│   │
│   ├── screens/
│   │   ├── accessibility/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── locations/
│   │   ├── onboarding/
│   │   ├── profile/
│   │   ├── reports/
│   │   ├── routes/
│   │   └── splash/
│   │
│   ├── services/
│   │   ├── api_service.dart
│   │   └── preferences_service.dart
│   │
│   ├── theme/
│   │   ├── app_colors.dart
│   │   └── app_theme.dart
│   │
│   ├── widgets/
│   │   ├── app_navigation.dart
│   │   ├── brand_mark.dart
│   │   └── primary_button.dart
│   │
│   └── main.dart
│
├── test/
├── pubspec.yaml
└── README.md
```

### Separação de responsabilidades

- **app:** configuração geral e navegação.
- **models:** representação e conversão dos dados.
- **screens:** telas e interfaces do aplicativo.
- **services:** comunicação com API e persistência local.
- **theme:** cores e configurações visuais.
- **widgets:** componentes reutilizáveis.

O gerenciamento de estado utiliza StatefulWidget, StatelessWidget e setState, conforme a necessidade de atualização da interface.

## 8. Persistência local

O pacote SharedPreferences é utilizado para armazenar preferências do usuário, incluindo:

- Preferência de exibição do onboarding.
- Configurações de acessibilidade.

Senhas e informações sensíveis não devem ser armazenadas diretamente no SharedPreferences.

## 9. Identidade visual

O Mobility+ utiliza uma identidade visual minimalista e moderna, com predominância de azul, ciano e fundos claros.

A proposta visual busca proporcionar:
- Clareza na apresentação das informações.
- Boa legibilidade.
- Navegação intuitiva.
- Consistência entre as telas.
- Facilidade de interação.

## 10. Como executar o projeto

### Pré-requisitos

- Flutter SDK instalado.
- Dart SDK compatível com a versão do Flutter.
- Android Studio com Android SDK ou navegador Google Chrome.
- Conexão com a internet para consultar a API.

### Instalação das dependências

Na pasta raiz do projeto, execute:

```bash
flutter pub get
```

### Executar no Chrome

```bash
flutter run -d chrome
```

### Executar em dispositivo Android

```bash
flutter run
```

### Gerar APK

```bash
flutter build apk
```

## 11. Testes e validação

Para verificar a qualidade e a compilação do projeto, executar:

```bash
flutter analyze
flutter test
flutter build apk
```

Também devem ser realizados testes manuais de navegação, onboarding, pesquisa de locais, consulta à API, detalhes dos estabelecimentos e interações disponíveis.

## 12. Desenvolvedores

| Integrante | RM |
|---|---|
| Keyla Dayana Magne Ala | 557630 |
| Beatriz Matos Marquez Rosa | 554805 |
| Lara Rosa Sodré | 555496 |

## 13. Repositório GitHub

**Projeto:** MobilityPlus

**Link:** https://github.com/keyladayanaj/MobilityPlus.git

## 14. Evidências e apresentação

As capturas de tela do aplicativo devem ser adicionadas ao diretório `docs/screenshots/`, contemplando:

- Splash Screen.
- Onboarding.
- Tela inicial.
- Menu principal.
- Pesquisa de locais.
- Detalhes de um local.
- Rotas.
- Perfil.
- Estados de carregamento e erro da API.

**Vídeo pitch:** [colocar link aqui]

---

**Mobility+ — Mobilidade inclusiva para todos.**

*Projeto acadêmico desenvolvido para a Global Solution FIAP.*


### Navegação ativa

Após calcular uma rota, o usuário pode selecionar **Iniciar navegação**. O aplicativo solicita a permissão de localização do navegador/dispositivo, acompanha a posição GPS durante o percurso, centraliza o mapa na posição atual e apresenta a próxima instrução de direção fornecida pelas etapas do OSRM. A navegação pode ser encerrada pelo próprio usuário.

**Limitação:** o trajeto é calculado pelo perfil de direção de carro do OSRM. As opções de evitar escadas e priorizar rampas ainda não alteram o algoritmo de roteamento. A navegação não detecta automaticamente obstáculos e não garante acessibilidade do percurso.
