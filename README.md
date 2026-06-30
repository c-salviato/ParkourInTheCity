# Parkour In The City

Parkour In The City é um jogo de parkour em terminal desenvolvido como trabalho da disciplina de Arquitetura e Organização de Computadores, do professor Djonatham. A ideia do projeto é controlar um personagem que salta entre prédios, coleta itens e avança por fases cada vez mais desafiadoras.

## Propósito do projeto

O projeto foi criado para praticar conceitos de baixo nível, organização de memória, manipulação de entrada e saída e lógica de jogo em Assembly. Ele também serve como demonstração de como montar uma experiência interativa usando apenas texto no terminal.

## Tecnologias utilizadas

- Assembly x86-64
- NASM como montador
- Windows como plataforma de execução
- Saída em modo texto no terminal com arte em ASCII

## Bibliotecas e funções utilizadas

- `printf` para exibir o mapa, menus e telas de estado do jogo
- `Sleep` para controlar pequenas pausas entre atualizações
- `GetAsyncKeyState` para ler as teclas pressionadas em tempo real
- `GetTickCount64` para acompanhar o tempo total da partida

## Resumo

O jogo usa mapas em ASCII, progresso por fases e coleta de itens para representar a progressão do personagem. Como é um trabalho acadêmico, o foco está mais na lógica em Assembly e no uso direto de recursos do sistema do que em gráficos ou bibliotecas de alto nível.