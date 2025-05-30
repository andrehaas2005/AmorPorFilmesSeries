# **Documento de Projeto: Amor por Filmes e Séries (Em construção)**

## **1\. Introdução**

Este documento detalha a concepção e a arquitetura de um aplicativo mobile iOS dedicado a filmes e séries, desenvolvido em Swift utilizando o framework UIKit. O projeto visa oferecer uma experiência rica ao usuário, com funcionalidades de autenticação completa, uma tela inicial dinâmica com carrosséis de conteúdo e telas de detalhe interativas. A ênfase é colocada na aplicação de uma arquitetura robusta (MVVM-C), melhores práticas de desenvolvimento, padrões de design e uma estratégia abrangente de testes.

## **2\. Visão Geral do Projeto**

O aplicativo "AmorPorFilmesSeries" é uma plataforma mobile para entusiastas de filmes e séries, oferecendo as seguintes funcionalidades principais:

* **Autenticação Completa:**  
  * **Tela de Login:** Permite que usuários existentes acessem suas contas com email e senha.  
  * **Tela de Cadastro (Sign Up):** Permite que novos usuários criem contas, fornecendo email, senha (com confirmação), nome, apelido e a seleção de múltiplos gêneros preferidos de filmes e séries, que são carregados de uma API.  
  * **Verificação de Email:** Um token de confirmação é enviado para o email do usuário durante o cadastro e deve ser verificado em uma tela dedicada para ativar a conta.  
* **Tela Inicial (Home):**  
  * Apresenta uma interface rica e dinâmica com múltiplos carrosséis (UICollectionView) de conteúdo:  
    * **Filmes em Lançamento:** Carrossel com imagens e nomes de filmes recém-lançados.  
    * **Filmes em Breve:** Carrossel de filmes que serão lançados em breve.  
    * **Atores Famosos:** Carrossel com fotos circulares e nomes de atores populares.  
    * **Filmes Recentemente Assistidos:** Carrossel estilo vitrine com filmes que o usuário assistiu recentemente.  
    * **Últimos Capítulos de Séries:** Carrossel estilo vitrine mostrando os últimos episódios de séries assistidas e não finalizadas.  
* **Tela de Detalhes:** Ao selecionar qualquer item de qualquer carrossel, o usuário é direcionado para uma tela de detalhes que exibe informações aprofundadas sobre o filme, série ou ator selecionado.

**Tecnologias:**

* **Plataforma:** iOS  
* **Linguagem:** Swift  
* **Framework UI:** UIKit (Programmatic UI)  
* **Gerenciamento de Dependências:** Swift Package Manager (SPM) para a camada de serviço (APIs) e futuras modularizações. Hoje como forma de apresentação a camada que lista Filme e outro com a lista de Séries

## **3\. Arquitetura: MVVM-C (Model-View-ViewModel-Coordinator)**

A arquitetura MVVM-C é a base para a organização e o desenvolvimento deste projeto, promovendo a separação de responsabilidades, a testabilidade e a manutenibilidade.

* **Model:**  
  * Representa os dados e a lógica de negócios da aplicação.  
  * São estruturas (structs) ou classes que encapsulam informações (e.g., Movie, Serie, Actor, Genre, User).  
  * São independentes da interface do usuário.  
  * **Exemplo:** struct Movie { let title: String; let posterURL: URL; ... }  
* **View:**  
  * É a camada de apresentação, responsável por exibir a interface do usuário.  
  * No UIKit, consiste em UIViewControllers e UIViews customizadas.  
  * A View é "passiva" e "burra"; ela apenas exibe os dados que recebe do ViewModel e encaminha as interações do usuário (toques, digitação) para o ViewModel. Não contém lógica de negócios.  
  * **UIViewController:** Atua como um intermediário, instanciando o ViewModel, configurando os *bindings* (observadores de dados) e delegando ações da UI.  
  * **UIView (Customizada):** É onde a hierarquia visual dos elementos da UI (botões, campos de texto, labels, coleções) é construída, mantendo o UIViewController mais limpo.  
* **ViewModel:**  
  * A "ponte" entre o Model e a View.  
  * Contém a lógica de apresentação e transforma os dados do Model em um formato que a View pode exibir facilmente.  
  * Expõe propriedades "observáveis" (utilizando um padrão Observable customizado ou Combine) que a View pode "bindar" para atualizar sua UI automaticamente.  
  * Lida com as ações do usuário (e.g., login(), signUp()) e interage com a camada de serviços para buscar ou enviar dados.  
  * Não tem conhecimento direto da View, comunicando-se através dos *bindings*.  
* **Coordinator:**  
  * Gerencia a navegação e o fluxo da aplicação, removendo essa responsabilidade dos ViewControllers.  
  * Cada Coordinator é responsável por um fluxo específico (e.g., AuthCoordinator para autenticação, HomeCoordinator para a tela principal).  
  * Coordinators podem ter coordenadores filhos (childCoordinators), formando uma hierarquia que facilita a gestão de fluxos complexos e a reutilização.

**Benefícios do MVVM-C:**

* **Separação Clara de Responsabilidades:** Cada componente tem uma função bem definida, facilitando o entendimento e a manutenção do código.  
* **Alta Testabilidade:** ViewModels e serviços podem ser testados unitariamente de forma isolada, sem a necessidade de uma UI. A lógica de navegação dos Coordinators também é testável.  
* **Reutilização de Componentes:** Views e ViewModels são desacoplados, permitindo sua reutilização em diferentes contextos ou fluxos.  
* **Manutenibilidade Aprimorada:** O baixo acoplamento entre os módulos significa que mudanças em uma parte do código têm menos impacto em outras.  
* **Gerenciamento de Navegação:** O Coordinator centraliza e organiza a lógica de navegação, tornando-a mais explícita e fácil de gerenciar.

## **4\. Estrutura do Projeto**

A organização de pastas e arquivos foi pensada para escalabilidade e futura modularização em Swift Packages (SPM), onde cada *feature* pode se tornar um módulo independente.

AmorPorFilmesSeries/  
├── App/  
│   ├── AppDelegate.swift  
│   ├── SceneDelegate.swift  
│   ├── Coordinator/  
│   │   └── AppCoordinator.swift  
│   └── Extensions/  
│       └── ... (Extensões úteis para UIKit, como Observable)  
├── Common/  
│   ├── Models/  
│   │   ├── Movie.swift  
│   │   ├── Serie.swift  
│   │   ├── Actor.swift  
│   │   ├── Genre.swift  
│   │   └── User.swift  
│   ├── Views/  
│   │   ├── GenreSelectionCell.swift (Célula reutilizável para seleção de gêneros)  
│   │   └── ... (Outras views customizadas reutilizáveis)  
│   └── Components/  
│       └── ... (Componentes de UI reutilizáveis, como botões customizados, se necessário)  
├── Features/  
│   ├── Auth/  
│   │   ├── Login/  
│   │   │   ├── View/  
│   │   │   │   ├── LoginViewController.swift  
│   │   │   │   └── LoginView.swift  
│   │   │   ├── ViewModel/  
│   │   │   │   └── LoginViewModel.swift  
│   │   │   └── Coordinator/  
│   │   │       └── LoginCoordinator.swift  
│   │   ├── SignUp/  
│   │   │   ├── View/  
│   │   │   │   ├── SignUpViewController.swift  
│   │   │   │   └── SignUpView.swift  
│   │   │   ├── ViewModel/  
│   │   │   │   └── SignUpViewModel.swift  
│   │   │   └── Coordinator/  
│   │   │       └── SignUpCoordinator.swift  
│   │   └── EmailVerification/  
│   │       ├── View/  
│   │       │   ├── EmailVerificationViewController.swift  
│   │       │   └── EmailVerificationView.swift  
│   │       ├── ViewModel/  
│   │       │   │   └── EmailVerificationViewModel.swift  
│   │       │   └── Coordinator/  
│   │       │       └── EmailVerificationCoordinator.swift  
│   │       └── Coordinator/  
│   │           └── AuthCoordinator.swift (Coordenador pai para o fluxo de autenticação)  
│   ├── Home/  
│   │   ├── View/  
│   │   │   ├── HomeViewController.swift  
│   │   │   └── HomeView.swift  
│   │   ├── ViewModel/  
│   │   │   └── HomeViewModel.swift  
│   │   ├── Coordinator/  
│   │   │   └── HomeCoordinator.swift  
│   │   └── Cells/  
│   │       ├── MovieCarouselCell.swift  
│   │       ├── UpcomingMovieCell.swift  
│   │       ├── ActorCarouselCell.swift  
│   │       ├── RecentlyWatchedMovieCell.swift  
│   │       └── LastSerieEpisodeCell.swift  
│   ├── Details/  
│   │   ├── View/  
│   │   │   ├── DetailsViewController.swift  
│   │   │   └── DetailsView.swift  
│   │   ├── ViewModel/  
│   │   │   └── DetailsViewModel.swift  
│   │   └── Coordinator/  
│   │       └── DetailsCoordinator.swift  
│   └── ... (Outras features como Listagem de Filmes, Listagem de Séries, etc.)  
├── Services/  
│   ├── APIClient.swift (Camada de serviço via SPM)  
│   ├── Models/  
│   │   └── ... (Modelos específicos da API, se houver)  
│   └── Protocols/  
│       ├── UserService.swift (Protocolo para o serviço de usuário)  
│       └── ... (Outros protocolos de serviço)  
├── Resources/  
│   ├── Assets.xcassets/  
│   └── ... (Outros recursos como fontes, arquivos de configuração)  
└── Tests/  
    ├── UnitTests/  
    │   ├── Auth/  
    │   │   ├── LoginViewModelTests.swift  
    │   │   └── SignUpViewModelTests.swift  
    │   │   └── EmailVerificationViewModelTests.swift  
    │   └── Home/  
    │       └── HomeViewModelTests.swift  
    └── UITests/  
        └── MovieAppUITests.swift

**Explicação das Pastas:**

* **App/:** Contém os arquivos de inicialização do aplicativo (AppDelegate, SceneDelegate) e o AppCoordinator (o coordenador raiz que orquestra o fluxo geral).  
* **Common/:** Armazena modelos de dados genéricos, views customizadas e componentes de UI que são reutilizáveis em várias *features*.  
* **Features/:** O coração do projeto, onde cada funcionalidade principal é organizada em seu próprio diretório. Cada *feature* (e.g., Auth, Home, Details) segue a estrutura MVVM-C com suas subpastas View, ViewModel, Coordinator e, se aplicável, Cells.  
* **Services/:** Contém a camada de serviço da aplicação, responsável pela comunicação com APIs externas. Inclui protocolos de serviço para facilitar a injeção de dependência e o *mocking* em testes.  
* **Resources/:** Para ativos estáticos do projeto, como imagens, ícones e fontes.  
* **Tests/:** Contém os testes unitários e de UI, espelhando a estrutura do código fonte para facilitar a localização dos testes correspondentes.

## **5\. Destaques da Implementação**

### **5.1. Fluxo de Autenticação (Login, Cadastro, Verificação de Email)**

O fluxo de autenticação é um exemplo claro da aplicação do MVVM-C:

* **Views:** LoginViewController / LoginView, SignUpViewController / SignUpView, EmailVerificationViewController / EmailVerificationView. São responsáveis pela apresentação visual e coleta de entrada do usuário.  
* **ViewModels:** LoginViewModel, SignUpViewModel, EmailVerificationViewModel. Contêm a lógica de validação de entrada, interagem com o UserService (mockado para demonstração) e expõem estados de UI (mensagens de erro, estado de carregamento, sucesso) para as Views através de propriedades observáveis.  
* **Coordinators:** LoginCoordinator, SignUpCoordinator, EmailVerificationCoordinator. Gerenciam a navegação entre as telas de autenticação e delegam o controle de volta ao AuthCoordinator (o coordenador pai do fluxo de autenticação) quando um sub-fluxo é concluído. O AuthCoordinator, por sua vez, informa o AppCoordinator sobre o sucesso da autenticação.  
* **Seleção de Gêneros no Cadastro:** A tela de cadastro inclui uma UICollectionView para a seleção múltipla de gêneros. O SignUpViewModel gerencia a lista de gêneros disponíveis (buscados de uma API) e os gêneros selecionados pelo usuário, atualizando a UICollectionView através de *bindings*.

### **5.2. Tela Inicial (Home)**

A tela Home é o ponto central de exibição de conteúdo:

* **HomeViewController / HomeView:** Orquestra a exibição dos múltiplos carrosséis.  
* **HomeViewModel:** Será responsável por buscar os dados de filmes em lançamento, filmes em breve, atores famosos, filmes recentemente assistidos e séries em andamento através dos serviços apropriados. Ele exporá coleções de dados observáveis para que a HomeView possa popular suas UICollectionViews.  
* **Carrosséis (UICollectionView):** Cada tipo de conteúdo (filmes, atores, séries) será exibido em um carrossel horizontal, utilizando UICollectionView com células customizadas para cada tipo de item.  
  * **Células Customizadas:** MovieCarouselCell, UpcomingMovieCell, ActorCarouselCell, RecentlyWatchedMovieCell, LastSerieEpisodeCell. Cada célula será projetada para exibir a imagem e o nome do item de forma adequada (e.g., fotos circulares para atores, imagens retangulares para filmes/séries).  
* **Navegação:** A seleção de qualquer item em um carrossel acionará uma navegação para a DetailsViewController, gerenciada pelo HomeCoordinator.

### **5.3. Tela de Detalhes**

* **DetailsViewController / DetailsView:** Exibe informações detalhadas sobre o filme, série ou ator selecionado.  
* **DetailsViewModel:** Receberá o item selecionado e, se necessário, fará chamadas adicionais à API para obter dados mais completos sobre o item antes de expô-los à View.  
* **DetailsCoordinator:** Gerencia a apresentação da tela de detalhes.

## **6\. Padrões de Design Aplicados**

Além do MVVM-C como padrão arquitetural, o projeto incorpora outros padrões de design para promover um código limpo e eficiente:

* **Observer Pattern:** Implementado através da classe Observable\<T\> (ou similar, como Combine), permitindo que a View observe as mudanças nas propriedades do ViewModel e reaja a elas, mantendo a UI sincronizada com o estado dos dados.  
* **Delegate Pattern:** Amplamente utilizado para comunicação entre componentes, como UIViewControllers e seus Coordinators, ou para a conformidade com protocolos do UIKit como UICollectionViewDelegate e UICollectionViewDataSource.  
* **Dependency Injection:** As dependências (e.g., serviços de API) são injetadas nos ViewModels e Coordinators através de seus inicializadores. Isso aumenta a flexibilidade, a testabilidade e o desacoplamento.  
* **Factory Method (Implícito):** Os Coordinators atuam como "fábricas" ao criar e configurar ViewControllers e seus ViewModels associados, injetando as dependências necessárias.

## **7\. Melhores Práticas de Desenvolvimento**

* **Programmatic UI:** Toda a interface do usuário é construída via código, utilizando NSLayoutConstraints. Isso oferece maior controle sobre o layout, facilita a revisão de código, a colaboração e minimiza problemas de *merge* comuns com Storyboards.  
* **Extensões para Organização:** O uso de extensions para organizar o código em UIViewControllers, separando a configuração de *bindings*, alvos de botões e conformidade a protocolos.  
* **Reutilização de Células:** Implementação eficiente da reutilização de células de UICollectionView para otimizar o desempenho e o uso de memória.  
* **Tratamento de Erros:** Mensagens de erro claras são expostas pelo ViewModel e apresentadas ao usuário através de UIAlertControllers na View.  
* **Indicadores de Carregamento:** O estado de carregamento (isLoading) é gerenciado pelo ViewModel para fornecer feedback visual ao usuário durante operações assíncronas (e.g., desabilitando botões, mostrando um indicador de atividade).  
* **Operações Assíncronas:** Todas as operações de rede e tarefas demoradas são executadas em *background threads*, com as atualizações da UI sempre realizadas na *main thread* (DispatchQueue.main.async) para garantir uma experiência de usuário fluida.  
* **Referências Fracas (weak var):** Utilização de referências fracas para *delegates* e parentCoordinator para prevenir ciclos de retenção de memória e vazamentos de memória.  
* **Validação de Entrada:** O ViewModel é responsável por validar as entradas do usuário (e.g., campos vazios, senhas que não coincidem) antes de processar ou enviar os dados.

## **8\. Estratégia de Testes**

Uma estratégia de testes robusta é fundamental para garantir a qualidade e a estabilidade do aplicativo.

* **Testes Unitários:**  
  * Focam em testar unidades isoladas de código, principalmente os **ViewModels** e os **Serviços**.  
  * Mocks são amplamente utilizados para simular as dependências (e.g., MockAuthService, MockUserService, MockCoordinator), permitindo que a lógica dos ViewModels seja testada de forma isolada e previsível.  
  * **Exemplos:** Testes para cenários de login bem-sucedido, falha de login (credenciais inválidas, campos vazios), registro de usuário, seleção de gêneros, verificação de email.  
* **Testes de UI (Interface do Usuário):**  
  * Verificam o comportamento da interface do usuário e os fluxos de ponta a ponta da aplicação.  
  * Simulam interações do usuário (toques em botões, digitação em campos, rolagem) e verificam se a UI responde conforme o esperado e se a navegação ocorre corretamente.  
  * **Exemplos:** Testar o fluxo completo de login, o fluxo de cadastro (incluindo seleção de gêneros e verificação de email), e a navegação da Home para a tela de Detalhes.

## **9\. Considerações Futuras**

O projeto foi estruturado com a escalabilidade em mente, permitindo futuras expansões e melhorias:

* **Integração com APIs Reais:** Substituir os serviços mockados por implementações que se comunicam com as APIs reais de filmes e séries.  
* **Bibliotecas de Carregamento de Imagens:** Integrar bibliotecas como Kingfisher ou SDWebImage para um carregamento assíncrono e eficiente de imagens nas UIImageViews, com cache e tratamento de placeholders.  
* **Persistência de Dados Robustas:** Para funcionalidades como "filmes recentemente assistidos" e "últimos capítulos de séries", considerar soluções de persistência como Core Data ou Realm para um gerenciamento de dados mais complexo e escalável, em vez de apenas UserDefaults.  
* **Modularização Completa com SPM:** Separar cada *feature* em seu próprio Swift Package Manager, criando um projeto mais modular e com tempos de compilação otimizados.  
* **Aprimoramentos de UI/UX:** Adicionar animações, transições personalizadas e um design mais elaborado para uma experiência de usuário ainda mais rica.  
* **Funcionalidades Adicionais:** Implementar busca de filmes/séries, favoritos, perfis de usuário, etc.

## **10\. Conclusão**

Este documento apresenta um plano detalhado para o desenvolvimento de um aplicativo mobile iOS de filmes e séries, com foco em uma arquitetura sólida (MVVM-C), boas práticas de codificação e uma abordagem abrangente para testes. A estrutura modular do projeto garante que ele possa crescer e evoluir de forma eficiente, adaptando-se a novas funcionalidades e requisitos. A aplicação desses princípios resultará em um produto de alta qualidade, manutenível e testável, pronto para ser expandido e apresentado.
