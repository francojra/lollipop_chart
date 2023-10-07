
# Destaque de um grupo em gráficos lollipop ------------------------------------------------------------------------------------------------
# Autora do script: Jeanne Franco ----------------------------------------------------------------------------------------------------------
# Data: 06/10/23 ---------------------------------------------------------------------------------------------------------------------------
# Referência: https://r-graph-gallery.com/304-highlight-a-group-in-lollipop.html -----------------------------------------------------------

# Introdução -------------------------------------------------------------------------------------------------------------------------------

### Este post descreve como construir um gráfico 'pirulito' (lollipop) com R e ggplot2.
### Aqui mostramos como destacar um ou vários grupos de interesse para transmitir sua
### mensagem mais eficientemente.

### Anotações é ponto chave na visualização de dados: elas permitem ao leitor focar
### sobre a mensagem principal que quer ser transmitida.

### Se um ou poucos grupos interessam a você,é uma boa ideia destacar eles em um gráfico.
### O leitor irá entender mais rapidamente qual a história por trás do gráfico.

### Sendo assim, você pode usar o ifelse para mudar tamanho, cor e transparência, entre
### outros aesthetics. Além disso, é ainda mais esclarecedor adicionar textos ao gráfico.

# Criando o gráfico ------------------------------------------------------------------------------------------------------------------------

### Carregar pacotes

library(ggplot2)
library(dplyr)
library(hrbrthemes)

### Criar conjunto de dados

set.seed(1000)
data <- data.frame(
  x = LETTERS[1:26], 
  y = abs(rnorm(26))
)
View(data)

### Reordenar os dados

data <- data %>%
  arrange(y) %>%
  mutate(x = factor(x,x))
View(data)

### Gráfico

p <- ggplot(data, aes(x = x, y = y)) +
  geom_segment(aes(x = x, xend = x, y = 0, yend = y), 
    color = ifelse(data$x %in% c("A","D"), "orange", "grey"), 
    size = ifelse(data$x %in% c("A","D"), 1.3, 0.7)) +
  geom_point(color = ifelse(data$x %in% c("A","D"), "orange", "grey"), 
             size = ifelse(data$x %in% c("A","D"), 5, 2)) +
  theme_ipsum() +
  coord_flip() +
  theme(legend.position = "none") +
  xlab("") +
  ylab("Value of Y") +
  ggtitle("How did groups A and D perform?")
p

### Adicionar anotações

p + annotate("text", x = grep("D", data$x), 
                     y = data$y[which(data$x == "D")]*1.2, 
           label = "Group D is very impressive", 
           color = "orange", size = 4  , angle = 0, fontface = "bold", hjust = 0) + 
  
    annotate("text", x = grep("A", data$x), 
             y = data$y[which(data$x == "A")]*1.2, 
           label = paste("Group A is not too bad\n (val=",data$y[which(data$x == "A")] %>% 
                           round(2),")",sep = "" ) , 
           color = "orange", size = 4 , angle = 0, fontface = "bold", hjust = 0) 
