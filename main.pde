String[] bancoPalavras = {
  "pedra", "nuvem", "cinto", "lente", "festa", "piano"
};

String palavraSecreta;

// jogo
int maxLinhas = 6;
int tamanho = 5;

String[] historico = new String[maxLinhas];
int linhaAtual = 0;
String entrada = "";

int[][] cores = new int[maxLinhas][tamanho];

// forca
int falhas = 0;
int limiteFalhas = 6;

// controle
boolean fim = false;
boolean ganhou = false;
int cena = 0; // 0 menu | 1 jogo

void setup() {
  size(900, 600);
  textAlign(CENTER, CENTER);
  rectMode(CENTER);
  iniciarJogo();
}


void draw() {
  background(240);

  if (cena == 0) {
    telaInicial();
  } else {
    telaJogo();
  }
}

void telaInicial() {
  fill(0);
  textSize(48);
  text("JOGO DE PALAVRA", width/2, 150);

  botao(width/2, 300, 220, 60, "COMEÇAR");
}

void telaJogo() {
  titulo();
  desenharTabela();
  mostrarDigitacao();
  desenharBoneco(650, 150);
  infoFinal();

  if (fim) {
    botao(width/2, 540, 200, 50, "JOGAR NOVAMENTE");
  }
}


void keyPressed() {
  if (cena != 1 || fim) return;

  if (key == ENTER) {
    if (entrada.length() == tamanho) {
      verificar();
    }
    return;
  }

  if (key == BACKSPACE && entrada.length() > 0) {
    entrada = entrada.substring(0, entrada.length()-1);
    return;
  }

  if (key >= 'a' && key <= 'z' && entrada.length() < tamanho) {
    entrada += key;
  }
}

void mousePressed() {
  if (cena == 0) {
    if (clicou(width/2, 300, 220, 60)) {
      cena = 1;
      iniciarJogo();
    }
  } else if (fim) {
    if (clicou(width/2, 540, 200, 50)) {
      iniciarJogo();
    }
  }
}

void iniciarJogo() {
  palavraSecreta = bancoPalavras[int(random(bancoPalavras.length))];

  for (int i = 0; i < maxLinhas; i++) {
    historico[i] = "";
    for (int j = 0; j < tamanho; j++) {
      cores[i][j] = 0;
    }
  }

  linhaAtual = 0;
  entrada = "";
  falhas = 0;
  fim = false;
  ganhou = false;
}

void verificar() {
  historico[linhaAtual] = entrada;

  for (int i = 0; i < tamanho; i++) {
    char letra = entrada.charAt(i);

    if (letra == palavraSecreta.charAt(i)) {
      cores[linhaAtual][i] = 3;
    } else if (palavraSecreta.indexOf(letra) >= 0) {
      cores[linhaAtual][i] = 2;
    } else {
      cores[linhaAtual][i] = 1;
    }
  }

  if (entrada.equals(palavraSecreta)) {
    ganhou = true;
    fim = true;
  } else {
    falhas++;
    linhaAtual++;
  }

  entrada = "";

  if (linhaAtual >= maxLinhas || falhas >= limiteFalhas) {
    fim = true;
  }
}

void titulo() {
  fill(0);
  textSize(36);
  text("DESAFIO DAS PALAVRAS", width/2, 50);
}

void desenharTabela() {
  int baseX = 150;
  int baseY = 120;
  int tam = 60;

  textSize(24);

  for (int i = 0; i < maxLinhas; i++) {
    for (int j = 0; j < tamanho; j++) {

      int px = baseX + j * tam;
      int py = baseY + i * tam;

      switch(cores[i][j]) {
        case 3: fill(0, 170, 0); break;
        case 2: fill(200, 180, 0); break;
        case 1: fill(140); break;
        default: fill(210);
      }

      rect(px, py, tam, tam);

      fill(0);
      if (historico[i].length() > j) {
        text(historico[i].charAt(j), px, py);
      }
    }
  }
}

void mostrarDigitacao() {
  fill(0);
  textSize(20);
  text("Entrada: " + entrada, 300, 500);
}

void infoFinal() {
  fill(0);
  textSize(18);
  text("Erros: " + falhas + "/" + limiteFalhas, 750, 500);

  if (fim) {
    textSize(28);

    if (ganhou) {
      fill(0, 150, 0);
      text("VOCÊ ACERTOU!", 750, 440);
    } else {
      fill(200, 0, 0);
      text("FIM DE JOGO", 750, 440);

      fill(0);
      textSize(16);
      text("Resposta: " + palavraSecreta, 750, 470);
    }
  }
}

void botao(int x, int y, int w, int h, String texto) {
  if (sobre(x, y, w, h)) fill(180);
  else fill(200);

  rect(x, y, w, h, 10);
  fill(0);
  textSize(20);
  text(texto, x, y);
}

boolean sobre(int x, int y, int w, int h) {
  return mouseX > x-w/2 && mouseX < x+w/2 &&
         mouseY > y-h/2 && mouseY < y+h/2;
}

boolean clicou(int x, int y, int w, int h) {
  return sobre(x, y, w, h);
}

void desenharBoneco(int x, int y) {
  stroke(0);
  strokeWeight(3);

  line(x, y+200, x+100, y+200);
  line(x+50, y+200, x+50, y);
  line(x+50, y, x+120, y);
  line(x+120, y, x+120, y+30);

  if (falhas > 0) ellipse(x+120, y+50, 30, 30);
  if (falhas > 1) line(x+120, y+65, x+120, y+130);
  if (falhas > 2) line(x+120, y+80, x+90, y+110);
  if (falhas > 3) line(x+120, y+80, x+150, y+110);
  if (falhas > 4) line(x+120, y+130, x+95, y+170);
  if (falhas > 5) line(x+120, y+130, x+145, y+170);

  noStroke();
}
