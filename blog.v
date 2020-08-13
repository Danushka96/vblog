module main

import vweb
import sqlite

struct App {
	pub mut:
		vweb vweb.Context
		db sqlite.DB
}

fn main() {
	vweb.run<App>(8081)
}

pub fn (mut app App) index() vweb.Result {
	articles := app.find_all_articles()
	return $vweb.html()
}

pub fn (mut app App) new() vweb.Result {
    return $vweb.html()
}

pub fn (mut app App) new_article() vweb.Result {
    println('inside the new Article')
	title := app.vweb.form['title']
	text := app.vweb.form['text']
	if title == '' || text == ''  {
		app.vweb.text('Empty text/title')
		return vweb.Result{}
	}
	article := Article{
		title: title
		text: text
	}
	println(article)
	sql app.db {
		insert article into Article
	}
	app.vweb.redirect('/')
	return vweb.Result{}
}

pub fn(app &App) init() {}

pub fn(mut app App) init_once() {
	db := sqlite.connect(':memory:') or {panic(err)}
	db.exec('create table `Article` (id integer primary key, title text default "", text text default "")')
	db.exec('insert into Article (title, text) values ("Hello, world!", "V is great.")')
	db.exec('insert into Article (title, text) values ("Second post.", "Hm... what should I write about?")')
	app.db = db
}