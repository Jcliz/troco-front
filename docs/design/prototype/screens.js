// Prints do protótipo: node shots.js <troco-prototipo.html> <pasta-de-saída>
const { chromium } = require('playwright');
const fs = require('fs');
(async () => {
  const [file, out] = process.argv.slice(2);
  const url = 'file://' + file;
  const br = await chromium.launch();
  const errs = [];
  for (const [w, h, tag] of [[1440, 900, 'desktop-1440'], [360, 780, 'celular-360']]) {
    const dir = `${out}/${tag}`; fs.mkdirSync(dir, { recursive: true });
    const pg = await br.newPage({ viewport: { width: w, height: h } });
    pg.setDefaultTimeout(5000);
    pg.on('pageerror', e => errs.push(tag + ' ' + e.message));
    await pg.addInitScript(() => { try { localStorage.setItem('troco-tema', 'sunset'); } catch (e) {} });
    const go = async (hash) => { await pg.goto('about:blank'); await pg.goto(url + hash); await pg.waitForTimeout(800); };
    const shot = async (name, full) => {
      await pg.waitForTimeout(700);
      if (full) {
        const sh = await pg.evaluate(() => document.documentElement.scrollHeight);
        await pg.setViewportSize({ width: w, height: Math.max(h, sh) }); await pg.waitForTimeout(400);
      }
      await pg.screenshot({ path: `${dir}/${name}.png` });
      await pg.setViewportSize({ width: w, height: h });
    };
    const t = async (name, fn, full = true) => { try { await fn(); await shot(name, full); } catch (e) { errs.push(`${tag} ${name}: ${e.message.split('\n')[0]}`); } };
    const screens = [
      ['01-login', '#login'], ['02-cadastro', '#cadastro'], ['03-recuperar-senha', '#recuperar'], ['04-redefinir-senha', '#redefinir'],
      ['05-redefinir-link-vencido', '#redefinir/expirado'], ['06-primeiro-acesso', '#primeiro-acesso'], ['07-termos', '#termos'],
      ['08-painel', '#painel'], ['10-lancamentos', '#lancamentos'],
      ['13-mes-fixas', '#mes/fixas'], ['14-mes-rendas-variaveis', '#mes/rendas'], ['15-mes-sazonais', '#mes/sazonais'], ['16-mes-meta-de-reserva', '#mes/reserva'],
      ['18-configuracoes-fixas', '#configuracoes/fixas'], ['19-configuracoes-categorias', '#configuracoes/categorias'], ['20-configuracoes-meta-de-reserva', '#configuracoes/reserva'],
      ['21-configuracoes-tema', '#configuracoes/tema'], ['22-configuracoes-perfil', '#configuracoes/perfil'], ['23-configuracoes-seus-dados', '#configuracoes/dados'],
    ];
    for (const [name, hash] of screens) await t(name, () => go(hash), !hash.match(/login|cadastro|recuperar|redefinir|primeiro/));
    await t('09-painel-conta-da-margem', async () => { await go('#painel'); await pg.evaluate(() => document.querySelectorAll('details.how').forEach(d => d.open = true)); });
    await t('11-lancamento-detalhe', async () => { await go('#lancamentos'); await pg.locator('button.entry:visible').first().click(); }, false);
    await t('12-novo-lancamento', async () => { await go('#lancamentos'); await pg.locator('[data-new]:visible').first().click(); }, false);
    await t('17-virar-o-mes', async () => { await go('#mes/fixas'); await pg.locator('[data-turnover]:visible').first().click(); }, false);
    await pg.close();
  }
  console.log(errs.join('\n') || 'no errors');
  await br.close();
})();
