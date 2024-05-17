#include <gtk/gtk.h>

static void print_hello (GtkWidget *widget, gpointer   data)
{
    g_print ("Hello World\n");
}

double find_root(double ina, double inb, size_t iters)
{
    double c = 1.12;
    return c;
}

static void
activate (GtkApplication *app, gpointer user_data)
{
    /* create a new window, and set its title */
    GtkWidget *window = gtk_application_window_new (app);
    gtk_window_set_title (GTK_WINDOW (window), "LAB 10");
    // gtk_window_set_default_size (GTK_WINDOW (window), 200, 200);
    gtk_container_set_border_width (GTK_CONTAINER (window), 10);

    /* Here we construct the container that is going pack our buttons */
    GtkWidget *grid = gtk_grid_new ();

    /* Pack the container in the window */
    gtk_container_add (GTK_CONTAINER (window), grid);

    GtkWidget *label_a = gtk_label_new ("X_start:");
    GtkWidget *label_b = gtk_label_new ("X_end:");
    GtkWidget *label_iters = gtk_label_new ("Iterations:");
    GtkWidget *label_root = gtk_label_new ("Root:");
    GtkWidget *output_root = gtk_label_new ("");

    // value, lower, upper, step_increment, page_increment, page_size
    GtkAdjustment *adjustment_a = gtk_adjustment_new (0, -1000.0, 1000.0, 0.01, 0.1, 0.0);
    GtkAdjustment *adjustment_b = gtk_adjustment_new (0, -1000.0, 1000.0, 0.01, 0.1, 0.0);
    GtkAdjustment *adjustment_iter = gtk_adjustment_new (0, 0, 100, 1, 1, 0.0);
    GtkWidget *spin_a = gtk_spin_button_new (adjustment_a, 0.0001, 2);
    GtkWidget *spin_b = gtk_spin_button_new (adjustment_b, 0.0001, 2);
    GtkWidget *spin_iter = gtk_spin_button_new (adjustment_iter, 0.0001, 0);

    GtkWidget *button = gtk_button_new_with_label ("Find root");
    g_signal_connect (button, "clicked", G_CALLBACK (print_hello), NULL);

    /* Place the first button in the grid cell (0, 0), and make it fill
    * just 1 cell horizontally and vertically (ie no spanning) */
    gtk_grid_attach (GTK_GRID (grid), label_a, 0, 0, 1, 1);
    gtk_grid_attach (GTK_GRID (grid), spin_a, 1, 0, 1, 1);
    gtk_grid_attach (GTK_GRID (grid), label_b, 0, 1, 1, 1);
    gtk_grid_attach (GTK_GRID (grid), spin_b, 1, 1, 1, 1);
    gtk_grid_attach (GTK_GRID (grid), label_iters, 0, 2, 1, 1);
    gtk_grid_attach (GTK_GRID (grid), spin_iter, 1, 2, 1, 1);
    gtk_grid_attach (GTK_GRID (grid), button, 0, 3, 2, 1);
    gtk_grid_attach (GTK_GRID (grid), label_root, 0, 4, 1, 1);
    gtk_grid_attach (GTK_GRID (grid), output_root, 1, 4, 1, 1);

    gtk_grid_attach (GTK_GRID (grid), button, 0, 1, 2, 1);

    /* Now that we are done packing our widgets, we show them all
    * in one go, by calling gtk_widget_show_all() on the window.
    * This call recursively calls gtk_widget_show() on all widgets
    * that are contained in the window, directly or indirectly.
    */
    gtk_widget_show_all (window);
}

int main (int    argc, char **argv)
{
    GtkApplication *app;
    int status;

    app = gtk_application_new ("org.gtk.example", G_APPLICATION_FLAGS_NONE);
    g_signal_connect (app, "activate", G_CALLBACK (activate), NULL);
    status = g_application_run (G_APPLICATION (app), argc, argv);
    g_object_unref (app);

    return status;
}