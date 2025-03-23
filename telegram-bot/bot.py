from telegram import Update
from telegram.ext import ApplicationBuilder, CallbackQueryHandler, ContextTypes

GAME_URL = "https://fa00-185-198-50-145.ngrok-free.app"
GAME_SHORT_NAME = "eglobal_test_game"

# Handler must be async in v20+
async def game_callback_query_handler(update: Update, context: ContextTypes.DEFAULT_TYPE):
    query = update.callback_query

    if query.game_short_name == GAME_SHORT_NAME:
        # Await this call so it's properly executed in an async context
        await query.answer(url=GAME_URL)
    else:
        await query.answer(text="Unknown game!", show_alert=True)

def main():
    # Build the application
    application = ApplicationBuilder().token("8109723466:AAExNScnj6rUCdpac5QEbHoadEXQO_8G294").build()

    # Register the callback query handler
    application.add_handler(CallbackQueryHandler(game_callback_query_handler))

    # Run polling (blocks until you press Ctrl+C)
    application.run_polling()

if __name__ == "__main__":
    main()