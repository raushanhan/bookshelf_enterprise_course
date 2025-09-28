package ru.kpfu.itis.bookshelf.util;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.util.Random;
import javax.imageio.ImageIO;

public class BookCoverGenerator {

    public static void main(String[] args) {
        createCover("Путь сквозь звезды", "D:\\server\\covers\\" + "put_skvoz_zvezdy.jpg" );
        createCover("Крылья Тагана", "D:\\server\\covers\\" + "krylya_tagana.jpg" );
        createCover("Тайна сердца", "D:\\server\\covers\\" + "taina_serdtsa.jpg" );
        createCover("Дом на окраине", "D:\\server\\covers\\" + "dom_na_okraine.jpg" );
    }

    public static void createCover(String title, String filename) {
        int width = 1080;
        int height = 1600;

        String[] colors = {"#E0C3FC", "#8EC5FC", "#F9F9F9", "#FFE0AC"};
        Color backgroundColor = Color.decode(colors[new Random().nextInt(colors.length)]);

        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g2d = image.createGraphics();

        g2d.setColor(backgroundColor);
        g2d.fillRect(0, 0, width, height);

        g2d.setColor(Color.BLACK);
        g2d.setFont(new Font("Arial", Font.BOLD, 80));

        FontMetrics fm = g2d.getFontMetrics();
        int textWidth = fm.stringWidth(title);
        int textHeight = fm.getAscent();

        int x = (width - textWidth) / 2;
        int y = (height - textHeight) / 2 + fm.getAscent();

        g2d.drawString(title, x, y);
        g2d.dispose();

        try {
            ImageIO.write(image, "png", new File(filename));
            System.out.println("Обложка сохранена как " + filename);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}