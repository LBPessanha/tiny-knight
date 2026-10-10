# 🗡️ Tiny Knight

![Godot](https://img.shields.io/badge/Godot-4.7-478CBF?style=for-the-badge&logo=godotengine&logoColor=white)
![GDScript](https://img.shields.io/badge/GDScript-100%25-355570?style=for-the-badge)
![Web](https://img.shields.io/badge/Plataforma-Web-E34F26?style=for-the-badge&logo=html5&logoColor=white)

> Um cavaleiro, uma ilha e uma horda de goblins que não para de crescer. Quanto tempo você consegue sobreviver?

### 🕹️ [Jogue agora no navegador (itch.io)](https://ldbarros.itch.io/tiny-knight)

<!-- Dica: grave um GIF curto do jogo, salve em docs/gameplay.gif e descomente a linha abaixo -->
<!-- ![Gameplay](docs/gameplay.gif) -->

---

## 📖 Sobre o projeto

**Tiny Knight** é um jogo 2D de sobrevivência com visão de cima (*top-down*), desenvolvido como projeto final do **Santander Bootcamp 2024 – Criando Jogos com Godot**, da [DIO](https://www.dio.me/).

O curso original foi gravado na **Godot 4.2**. Este projeto foi refeito do zero na **Godot 4.7**, adaptando as mudanças da engine pelo caminho (como a troca do `TileMap` pelo `TileMapLayer`).

## ✨ Funcionalidades

- ⚔️ **Combate** com ataques em 3 direções e área de acerto sincronizada com a animação
- 👺 **Goblins com tocha** que perseguem o jogador e atacam corpo a corpo
- 💣 **Goblins TNT** que mantêm distância e arremessam dinamites em arco (liberados após 1 minuto)
- 🐑 **Ovelhas** que vagam pela ilha, fogem ao serem atacadas e sempre deixam carne
- 🍖 **Drops aleatórios** de carne que recuperam a vida do jogador
- 📈 **Dificuldade em ondas**, que cresce com o tempo usando uma curva senoidal
- 🗺️ **Ilha** com planaltos, câmera que segue o jogador e limites do mundo
- 🎭 **Y Sort** para dar profundidade aos personagens
- 💾 **Recorde salvo** automaticamente (inclusive na versão web)
- 🎮 **Suporte a controle**, além de teclado e mouse

## 🎮 Controles

| Ação | Teclado / Mouse | Controle |
|---|---|---|
| Andar | WASD ou setas | Analógico esquerdo ou D-pad |
| Atacar | Espaço, J ou clique esquerdo | Botão de ação (X no Xbox / □ no PlayStation) |

## 🧠 Conceitos aplicados

| Conceito | Onde foi usado |
|---|---|
| Cenas e instâncias | Personagens, itens e interface montados como peças reutilizáveis |
| Sinais (*signals*) | Fim de animação, coleta de itens, vida do jogador e Game Over |
| Autoload (*singleton*) | `GameManager`: tempo, placar, recorde e estado do jogo |
| Collision Layers / Masks | Separação entre mundo, jogador, inimigos e animais |
| `Area2D` | Espada, explosão e coleta de carne |
| Máquina de estados simples | Comportamento das ovelhas (pastar, passear, fugir) |
| Tweens | Feedback de dano, invencibilidade, arco da dinamite e fade-in |
| `ConfigFile` + `user://` | Persistência do recorde |
| Exportação para web | Build *single-threaded* publicado no itch.io |

## 🛠️ Como rodar o projeto

1. Instale a [Godot 4.7](https://godotengine.org/) (versão padrão, não a .NET).
2. Clone o repositório:
   ```bash
   git clone https://github.com/LBPessanha/tiny-knight.git
   ```
3. Na Godot, clique em **Import** e selecione o arquivo `project.godot`.
4. Aperte **F5** para jogar.

## 📁 Estrutura

```
tiny-knight/
├── assets/     # Arte (Tiny Swords) e fonte
├── scenes/     # Cenas: player, inimigos, ovelha, itens, HUD, Game Over
└── scripts/    # Scripts GDScript
```

## 🏆 Créditos

- **Desenvolvimento:** [LBPessanha](https://github.com/LBPessanha)
- **Arte:** [Tiny Swords](https://pixelfrog-assets.itch.io/tiny-swords), por Pixel Frog (CC0)
- **Fonte:** [Pixelify Sans](https://fonts.google.com/specimen/Pixelify+Sans) (Google Fonts)
- **Curso:** Santander Bootcamp 2024 – Criando Jogos com Godot ([DIO](https://www.dio.me/)), com as aulas de Rafa Skoberg

---

## 🇺🇸 English

**Tiny Knight** is a top-down 2D survival game made with **Godot 4.7** as the final project of the *Santander Bootcamp 2024 – Creating Games with Godot* (DIO). Fight endless waves of goblins, dodge dynamite-throwing TNT goblins, hunt sheep for healing meat and beat your best time.

🕹️ **[Play it in your browser](https://ldbarros.itch.io/tiny-knight)**
