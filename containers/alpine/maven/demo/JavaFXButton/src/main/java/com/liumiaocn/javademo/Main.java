package com.liumiaocn.javademo;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;

public class Main extends Application {
	public static void main(String[] args) {
		launch(args);
	}

	@Override
	public void start(Stage primaryStage) throws Exception {
		final Stage window = new Stage();
		window.setX(40);
		Scene innerScene = new Scene(new Label("Show or Hide Me"),200,100);
		window.setScene(innerScene);
                window.setTitle("Show/Hide Window");

		HBox root = new HBox(200d);
		Button showButton = new Button("Show Window");
		showButton.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent event) {
				window.show();
			}
		});
		Button hideButton = new Button("Hide Window");
		hideButton.setOnAction(new EventHandler<ActionEvent>() {
			@Override
			public void handle(ActionEvent event) {
				window.hide();
			}
		});
		root.getChildren().add(showButton);
		root.getChildren().add(hideButton);
                primaryStage.setTitle("Hello LiuMiao");
		primaryStage.setScene(new Scene(root,600,600));
                
		primaryStage.show();
	}
}
